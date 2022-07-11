# Create VPC (optional)

In an enterprise, the creation of VPC and related resources, usually, is managed by a separate team. Sometimes it is part of the enterprise account vending process.

This is an example Terraform script, which creates the VPC resources required for this solution. This uses the well-known module [terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest) to create the VPC resources.

## Prerequisites

- Terraform backend provider and state locking providers are identified and bootstrapped.
  - A [bootstrap](../bootstrap) module/example is provided that provisions Amazon S3 for Terraform state storage and Amazon DynamoDB for Terraform state locking.

## Execution

- cd to `vpc` folder.
- Modify the `backend "S3"` section in `provider.tf` with correct values for `region`, `bucket`, `dynamodb_table`, and `key`.
  - Use provided values as guidance.
- Modify `terraform.tfvars` to your requirements.
  - Use provided values as guidance.
- Make sure you are using the correct AWS Profile that has permission to provision the target resources.
  - `aws sts get-caller-identity`
- Execute `terraform init` to initialize Terraform.
- Execute `terraform plan` and verify the changes.
- Execute `terraform apply` and approve changes to provision the resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= v1.1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.13.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.22.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 3.14.2 |

## Resources

| Name | Type |
|------|------|
| [aws_route53_zone.pvt_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Environment name e.g. dev, prod | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project to be used on all the resources identification | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS Region e.g. us-east-1 for the environment | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Mandatory tags for the resources | `map(string)` | n/a | yes |
| <a name="input_vpc_private_subnet_tags"></a> [vpc\_private\_subnet\_tags](#input\_vpc\_private\_subnet\_tags) | Tags for the private subnet | `map(string)` | n/a | yes |
| <a name="input_vpc_public_subnet_tags"></a> [vpc\_public\_subnet\_tags](#input\_vpc\_public\_subnet\_tags) | Tags for the public subnet | `map(string)` | n/a | yes |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | Tags for the VPC | `map(string)` | n/a | yes |
| <a name="input_r53_zone_names"></a> [r53\_zone\_names](#input\_r53\_zone\_names) | Private Route53 Zone names to create and associate with the VPC | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_r53_hosted_zones"></a> [r53\_hosted\_zones](#output\_r53\_hosted\_zones) | Route 53 hosted zones created |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC Id for the provisioned VPC |
| <a name="output_vpc_private_subnet_ids"></a> [vpc\_private\_subnet\_ids](#output\_vpc\_private\_subnet\_ids) | Subnet Id(s) for the provisioned public Subnets |
| <a name="output_vpc_public_subnet_ids"></a> [vpc\_public\_subnet\_ids](#output\_vpc\_public\_subnet\_ids) | Subnet Id(s) for the provisioned public Subnets |
<!-- END_TF_DOCS -->
