#!/bin/bash

input_component=$1
component_build_ids=$2
aws_region=$3

declare -A ECR_REPOSITORY_MAP=(
            ["OneOneOne"]="111"
            ["nhais"]="nhais"
            ["nhais_responder"]="nhais-fake-responder"
            ["gp2gp"]="gp2gp"
            ["lab-results"]="lab-results"
            ["pss"]="pss_gp2gp-translator"
            ["mhs"]="mhs/outbound"
            ["gpc-consumer"]="gpc-consumer"
)

get_primary_branch() {
    local component_name="$1"
    case "$component_name" in
        "nhais")
            echo "develop"
            ;;
        "nhais-fake-responder")
            echo "origin-develop"
            ;;
        *)
            echo "main"
            ;;
    esac
}

get_latest_tag() {
    local repository_name="$1"
    local region="$2"
    local branch_prefix="$3"

    aws ecr describe-images \
        --repository-name "$repository_name" \
        --region "$region" \
        --query "sort_by(imageDetails[?starts_with(imageTags[0], \`$branch_prefix\`)], &imagePushedAt)[-1].imageTags[0]" \
        --output text | awk '{print $1}'
}

fetch_latest_build_id() {
    local component="$1"
    local repo_name="${ECR_REPOSITORY_MAP[$component]:-}"

    if [[ -z "$repo_name" ]]; then
        echo "Error: No ECR repository mapped for component '$component'." >&2
        exit 1
    fi

    local primary_branch
    primary_branch=$(get_primary_branch "$component")
    echo "Fetching latest build tag for component '$component' from branch '$primary_branch'..." >&2

    local latest_tag
    latest_tag=$(get_latest_tag "$repo_name" "$aws_region" "$primary_branch")

    if [[ -z "$latest_tag" || "$latest_tag" == "None" ]]; then
        echo "Error: No builds found on branch '$primary_branch' for component '$component'." >&2
        exit 1
    fi

    echo "Latest build tag for '$component': '$latest_tag'" >&2
    build_ids_map["$component"]="$latest_tag"
}

validate_build_id() {
    local component="$1"
    local build_id="$2"
    local repo_name="${ECR_REPOSITORY_MAP[$component]:-}"

    if [[ -z "$repo_name" ]]; then
        echo "Error: No ECR repository mapped for component '$component'." >&2
        exit 1
    fi

    echo "Validating build ID '$build_id' for component '$component'..." >&2

    local exists
    if exists=$(aws ecr describe-images \
        --repository-name "$repo_name" \
        --region "$aws_region" \
        --image-ids imageTag="$build_id" \
        --query 'imageDetails' \
        --output json); then

        if [[ "$exists" == "[]" ]]; then
            echo "Error: Build tag '$build_id' does not exist for component '$component'." >&2
            exit 1
        else
            echo "Build tag '$build_id' for component '$component' is valid." >&2
        fi
    else
        echo "Error: Build tag '$build_id' could not be retrieved for '$component'." >&2
        exit 1
    fi
}

declare -A build_ids_map
IFS=',' read -ra pairs <<< "$component_build_ids"
for pair in "${pairs[@]}"; do
    IFS='=' read -r component build_id <<< "$pair"
    build_ids_map["$component"]="$build_id"
done

validated_build_ids_json='{}'

echo "Processing build IDs for component '$input_component'..." >&2

if [[ -z "${build_ids_map[$input_component]:-}" ]]; then
    echo "Component '$input_component' not found in provided build IDs. Retrieving latest build tag..." >&2
    fetch_latest_build_id "$input_component"
fi

if [[ "$input_component" == "gp2gp" && -z "${build_ids_map[gpc-consumer]:-}" ]]; then
    echo "Input component is 'gp2gp' and build ID for 'gpc-consumer' not provided. Retrieving latest build tag for 'gpc-consumer'..." >&2
    fetch_latest_build_id "gpc-consumer"
fi


for component in "${!build_ids_map[@]}"; do
    build_id="${build_ids_map[$component]}"
    validate_build_id "$component" "$build_id"

    validated_build_ids_json=$(echo "$validated_build_ids_json" \
                                    | jq -c --arg key "${component}_build_id" \
                                    --arg value "$build_id" \
                                    '.[$key] = $value')
done

echo "$validated_build_ids_json" >&1
exit 0