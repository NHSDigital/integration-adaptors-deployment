# Integration Adaptors Deployment

This repository contains the deployment terraform files for both AWS and Azure, for the following components:

* Base
* NHAIS
* 111
* MHS
* Account
* Fake Mesh
* NHAIS Responder
* GP2GP
* Lab Results
* PSS

## Deploying Components

Components Can be deployed using the GitHub action: [Manual Terraform Job](https://github.com/MartinWheelerMT/test-workflow-dispatch/actions/workflows/terraform-dispatch.yml)

Clicking `Run Workflow` will provide a number of configurable parameters to use for the deployment.
These will be detailed below:
* `Use Workflow From` - If a change to a GitHub action has been made on a separate branch, then this can be selected 
here to run that version of the action.
* `Project` - Currently only contains one value and defaults to `ptl`.
* `Terraform Action` - The terraform action you wish to complete with this deployment (i.e. `Plan`, `Apply`).
* `Component` - The component you wish to deploy (i.e. `gp2gp`, `pss`).
* `Component Build Ids` (Optional) - If you wish to provide a specific build ids for the deployment, these should be
included here, in the format (<component>=<build id>). Each build id should be separated by a single `,` and spaces
should not be used.  For example, if you wanted to deploy the `gp2gp` adaptor with a build id of `PR-718-10-3d333bf`,
and with a `gpc-consumer` with a build id of `PR-122-2-c86dc42`, then this input would be populated with
`gp2gp=PR-718-10-3d333bf,gpc-consumer=PR-122-2-c86dc42`.
*`Additional Terraform Variables` (Optional) - If you wish to provide additional variable for the deployment, then
these are included here in the format (<name>=<value>). Each variable is separated by a single `,` and spaces should
not be used. For example, if you wanted to enable the redactions when deploying the `gp2gp` adaptor them you should
populate the input with `gp2gp_redactions_enabled=true`.
* `Git Repository from which terraform will be read` - Enables you to change the repository used for the terraform
repository.  This defaults to the current repository and should not need to be changed under most circumstances.
* `Git Branch from which terraform will be taken` - Enables the selection of the branch within the above repository that 
terraform will be taken from.  This defaults to the `main` branch and will not need to be changed under most 
circumstances.