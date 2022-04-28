# Bootstrap Terraform backend

[Terraform Backends](https://www.terraform.io/language/settings/backends) defines where Terraform's state snapshots are stored. [Amazon S3 Backend](https://www.terraform.io/language/settings/backends/s3) stores the Terraform state as a given key in a given bucket on Amazon S3. This backend also supports state locking and consistency checking via Dynamo DB.

This is an example Terrafrom bootstrap script.

## Prerequisites

- Modify `terraform.tfvars`. Make sure to provide desired values for:
  - `region` --> Target AWS Regsion
  - `s3_statebucket_name` --> Globally unique Amazon S3 bucket name
  - `dynamo_locktable_name` --> DynamoDB table name used for state locking
- Modify `provider.tf`. Comment out the `backend` section.

    ```text
      # backend "s3" {
      #   ...
      # }
    ```

## Execution

- cd to `bootstrap` folder.
- Execute `terraform init` to initialize Terraform.
- Execute `terraform plan` and verify the changes.
- Execute `terraform apply` and approve the changes.
- Switch to using Amazon S3 backend by un-commenting the `backend "S3"` section within `provider.tf`
  - Modify `backend "S3"` section with correct values for `region`, `bucket`, `dynamodb_table`, and `key`. Use provided values as guidance.
- Execute `terraform init` to re-initilize Terraform with new backend.
  - This will ask you to move your state to Amazon S3. Enter 'yes'.
- Once you have your Terraform state on Amazon S3, you can continue to make updates to bootstrap as needed, using the Amazon S3 as backend.

<!-- BEGIN_TF_DOCS -->
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bootstrap"></a> [bootstrap](#module\_bootstrap) | ../modules/aws/bootstrap | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dynamo_locktable_name"></a> [dynamo\_locktable\_name](#input\_dynamo\_locktable\_name) | Name of the DynamoDB table used for Terraform state locking. | `string` | `""` | no |
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Environment name e.g. dev, prod | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project to be used on all the resources identification | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS Region e.g. us-east-1 for the environment | `string` | n/a | yes |
| <a name="input_s3_statebucket_name"></a> [s3\_statebucket\_name](#input\_s3\_statebucket\_name) | Globally unique name of the S3 bucket used for storing Terraform state files. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Mandatory tags for the resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_config"></a> [backend\_config](#output\_backend\_config) | Define the backend configuration with following values |
<!-- END_TF_DOCS -->