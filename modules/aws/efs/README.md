<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_efs_kms"></a> [efs\_kms](#module\_efs\_kms) | github.com/aws-samples/aws-tf-kms//modules/aws/kms | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_efs_access_point.efs_ap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point) | resource |
| [aws_efs_file_system.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_file_system_policy.efs-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system_policy) | resource |
| [aws_efs_mount_target.efs_mount](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_security_group.efs_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_efs_access_point_specs"></a> [efs\_access\_point\_specs](#input\_efs\_access\_point\_specs) | List of EFS Access Point Specs. | <pre>list(object({<br>    efs_name        = string # must match with any efs_specs.name<br>    efs_ap          = string # unique name<br>    uid             = number<br>    gid             = number<br>    root_path       = string # e.g. /{env}/{project}/{purpose}/{name}<br>    owner_uid       = number # e.g. 0<br>    owner_gid       = number # e.g. 0<br>    root_permission = string # e.g. 0755<br>  }))</pre> | `[]` | no |
| <a name="input_efs_port"></a> [efs\_port](#input\_efs\_port) | Ingress port for EFS | `number` | `2049` | no |
| <a name="input_efs_specs"></a> [efs\_specs](#input\_efs\_specs) | List of EFS Specs | <pre>list(object({<br>    name                = string # unique name<br>    efs_id              = string # if null, new EFS will be created<br>    encrypted           = bool<br>    performance_mode    = string<br>    transition_to_ia    = string<br>    backup_plan         = string<br>    security_group_tags = map(string) # if null, new Security Group will be created<br>  }))</pre> | n/a | yes |
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Environment name e.g. dev, prod | `string` | `"dev"` | no |
| <a name="input_kms_admin_roles"></a> [kms\_admin\_roles](#input\_kms\_admin\_roles) | List Administrator roles for KMS, Provide at least one Admin role if create\_kms is true | `list(string)` | `[]` | no |
| <a name="input_kms_alias"></a> [kms\_alias](#input\_kms\_alias) | Use the given alias or create a new KMS like alias/{var.project}/efs | `string` | `""` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name (prefix/suffix) to be used on all the resources identification | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS Region e.g. us-east-1 for the environment | `string` | n/a | yes |
| <a name="input_subnet_tags"></a> [subnet\_tags](#input\_subnet\_tags) | Tags to discover target subnets in the VPC, these tags should identify one or more subnets | `map(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Common and mandatory tags for the resources | `map(string)` | `{}` | no |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | Tags to discover target VPC, these tags should uniquely identify a VPC | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_efs"></a> [efs](#output\_efs) | Elastic File System info |
| <a name="output_efs_ap"></a> [efs\_ap](#output\_efs\_ap) | Elastic File System Access Point info |
| <a name="output_efs_kms"></a> [efs\_kms](#output\_efs\_kms) | Outputs from KMS module forwarded |
<!-- END_TF_DOCS -->
