component=$1
component_build_ids=$2
aws_region=$3

declare -A ecr_repo_map=(
            ["OneOneOne"]="111"
            ["nhais"]="nhais"
            ["nhais_responder"]="nhais-fake-responder"
            ["gp2gp"]="gp2gp"
            ["lab-results"]="lab-results"
            ["pss"]="pss_gp2gp-translator"
)

# Parse the input string into an associative array as 'build_ids_map'
declare -A build_ids_map
IFS=',' read -ra pairs <<< "$component_build_ids"
for pair in "${pairs[@]}"; do
  IFS='=' read -r component build_id <<< "$pair"
  build_ids_map["$component"]="$build_id"
done

# Initialize JSON output as 'validated_build_id_json'
validated_build_ids_json=$(echo '{}' | jq '.')

input_component=$component
echo "Processing build ids for '$input_component'..."

# Check if the specified component exists in the component_build_ids
if [[ -z "${build_ids_map[$input_component]}" ]]; then

  # get "main" branch for repository as 'primary_branch'
  if [ "$input_component" = "nhais" ]; then
    primary_branch="develop"
  elif [ "$input_component" = "nhais-fake-responder" ]; then
    primary_branch="origin-develop"
  else
    primary_branch="main"
  fi

  echo "Component '$input_component' not found in provided build ids."
  echo "Retrieving latest build tag from '$primary_branch' branch..."

  ecr_repo_name=${ecr_repo_map[$input_component]}

  latest_tag=$(aws ecr describe-images \
    --repository-name "$ecr_repo_name" \
    --region "$aws_region" \
    --query "sort_by(imageDetails[?starts_with(imageTags[0], \`$primary_branch\`)], &imagePushedAt)[-1].imageTags[0]" \
    --output text | head -n 1)

  # format the latest tag to ensure only the first build tag is used
  latest_tag=$(echo "$latest_tag" | tr -d '\n' | awk '{print $1}')

  if [[ "$latest_tag" == "None" || -z "$latest_tag" ]]; then
    echo "Error: No builds found on '$primary_branch' branch for component '$input_component'."
    exit 1
  else
    validated_build_ids_json=$(echo "$validated_build_ids_json" \
                                | jq -c --arg key "${input_component}_build_id" \
                                --arg value "$latest_tag" \
                                '.[$key] = $value')
    echo "Found latest build tag for '$input_component': '$latest_tag'"
  fi
fi

if [[ "$input_component" == "gp2gp" && -z "${build_ids_map[gpc-consumer]}" ]]; then
  echo "Provided component is gp2gp and build tag has been not provided for gpc-consumer".
  echo "Retrieving latest build tag for 'gpc-consumer'..."

  latest_tag=$(aws ecr describe-images \
    --repository-name "gpc-consumer" \
    --region "$aws_region" \
    --query "sort_by(imageDetails[?starts_with(imageTags[0], $(main))], &imagePushedAt)[-1].imageTags[0]" \
    --output text | head -n 1)

  # format the latest tag to ensure only the first build tag is used
  latest_tag=$(echo "$latest_tag" | tr -d '\n' | awk '{print $1}')

  if [[ "$latest_tag" == "None" || -z "$latest_tag" ]]; then
    echo "Error: No builds found on 'main' branch for component 'gpc-consumer'."
    exit 1
  else
    validated_build_ids_json=$(echo "$validated_build_ids_json" \
                                | jq -c --arg key "gpc-consumer_build_id" \
                                --arg value "$latest_tag" \
                                '.[$key] = $value')

     echo "Found latest build tag for 'gpc-consumer': '$latest_tag'."
  fi
fi

# Check existence of each image build_id in AWS ECR
for component in "${!build_ids_map[@]}"; do
  build_id="${build_ids_map[$component]}"
  echo "Validating $component with build tag: $build_id"

  # Check if the image build_id exists in the ECR repository
  result=$(aws ecr describe-images \
    --repository-name "$component" \
    --region "$aws_region" \
    --query "imageDetails[?imageTags && contains(imageTags, '$build_id')]" \
    --output json)

  if [[ "$result" == "[]" ]]; then
    echo "Error: Build tag '$build_id' does not exist for component '$component'."
    exit 1
  else
    echo "Found build tag for component '$component': '$build_id'."
    validated_build_ids_json=$(echo "$validated_build_ids_json" \
                                | jq -c --arg key "${component}_build_id" \
                                --arg value "$build_id" \
                                '.[$key] = $value')
  fi
done

echo "validated_build_ids=$validated_build_ids_json" >> "$GITHUB_OUTPUT"