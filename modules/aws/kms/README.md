<!-- BEGIN_TF_DOCS -->
## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.kms_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Environment name e.g. dev, prod | `string` | `"dev"` | no |
| <a name="input_kms_config"></a> [kms\_config](#input\_kms\_config) | The requested KMS configuration | <pre>object({<br>    kms_admin_roles     = list(string) #Provide at least one Admin role for KMS<br>    kms_usage_roles     = list(string) #Zero or more roles that need access to KMS<br>    prefix              = string #e.g. {project}<br>    keys_to_create      = list(string) #provide at least one [efs,ebs,logs,sns,sqs,backup,ssm,secretsmanager,session,rds,kinesis,s3]<br>    enable_key_rotation = bool<br>  })</pre> | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name (prefix/suffix) to be used on all the resources identification | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS Region e.g. us-east-1 for the environment | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Common and mandatory tags for the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_aliases"></a> [key\_aliases](#output\_key\_aliases) | KMS key aliases that are created |
<!-- END_TF_DOCS -->