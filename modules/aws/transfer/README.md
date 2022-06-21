<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_transfer_efs"></a> [transfer\_efs](#module\_transfer\_efs) | ../efs | n/a |
| <a name="module_transfer_kms"></a> [transfer\_kms](#module\_transfer\_kms) | github.com/aws-samples/aws-tf-kms//modules/aws/kms | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.create_daily_report](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_rule.create_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.create_user_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_event_target.create_user_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_event_target.report_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.lambda_insights](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.report_lambda_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.sftp_lambda_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.transfer_events](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.transfer_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_resource_policy.events_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy) | resource |
| [aws_iam_policy.sftp_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.transfer_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.transfer_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.sftp_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.transfer_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.transfer_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.sftp_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.transfer_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.transfer_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.report_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.sftp_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.report_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.sftp_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_route53_record.sftp_rec](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.lambda_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.sftp_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.allow_lambda_ingress_to_efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_sns_topic.sftp_daily_report](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic.sftp_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.sftp_daily_report](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.sftp_daily_report](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sns_topic_subscription.sftp_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_transfer_server.sftp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_server) | resource |
| [aws_transfer_ssh_key.sftp_user_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_ssh_key) | resource |
| [aws_transfer_user.sftp_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_user) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_common_logs"></a> [create\_common\_logs](#input\_create\_common\_logs) | Create the common CW log groups and other common resources | `bool` | `false` | no |
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Environment name e.g. dev, prod | `string` | `"dev"` | no |
| <a name="input_kms_admin_roles"></a> [kms\_admin\_roles](#input\_kms\_admin\_roles) | List Administrator roles for KMS, Provide at least one Admin role if create\_kms is true | `list(string)` | `[]` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name (prefix/suffix) to be used on all the resources identification | `string` | n/a | yes |
| <a name="input_r53_zone_name"></a> [r53\_zone\_name](#input\_r53\_zone\_name) | Route 53 Zone basename, If not nulls R53 record will be created for the SFTP server | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS Region e.g. us-east-1 for the environment | `string` | n/a | yes |
| <a name="input_sftp_daily_report_subscribers"></a> [sftp\_daily\_report\_subscribers](#input\_sftp\_daily\_report\_subscribers) | List of email address to which daily activity reports will be sent | `list(string)` | `[]` | no |
| <a name="input_sftp_specs"></a> [sftp\_specs](#input\_sftp\_specs) | Specs for the SFTP server | <pre>object({<br>    server_name = string #dns name compliant name prefix<br>    encryption = object({<br>      encrypt_logs     = bool   # default is false<br>      logs_kms_alias   = string # default is alias/{var.project}/logs<br>      encrypt_lambda   = bool   # default is false<br>      lambda_kms_alias = string # default is alias/{var.project}/lambda<br>      encrypt_sns      = bool   # default is false<br>      sns_kms_alias    = string # default is alias/{var.project}/sns<br>    })<br><br>    user_role    = string #if null, an IAM role for the SFTP user will be created<br>    logging_role = string #if null, an IAM role for the SFTP logging to CW will be created<br><br>    security_group = object({<br>      sftp_port    = number       #2049<br>      source_cidrs = list(string) #if [], the SFTP Security Group will not be created<br>      tags         = map(string)  #if provided, the identified SG will be attached<br>    })<br><br>    efs_specs = object({<br>      efs_id              = string      #if null, new EFS will be created<br>      efs_ap_id           = string      #if null, new EFS AP will be created<br>      security_group_tags = map(string) #if efs_id is not null, then it must be provided<br>      encryption          = bool<br>      kms_alias           = string<br>    })<br><br>    lambda_specs = object({<br>      execution_role                   = string      #if null, an IAM role for the SFTP User Automation Lambda will be created<br>      security_group_tags              = map(string) #if null, a Lambda security group will be created<br>      daily_report_schedule_expression = string      #e.g. cron(0 22 * * ? *)<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_sftp_user_automation_subscribers"></a> [sftp\_user\_automation\_subscribers](#input\_sftp\_user\_automation\_subscribers) | List of email address to which user automation event outcome will be sent | `list(string)` | `[]` | no |
| <a name="input_sftp_users"></a> [sftp\_users](#input\_sftp\_users) | List of SFTP Users | <pre>list(object({<br>    name         = string # e.g. test1<br>    uid          = string # e.g. 3001<br>    gid          = string # e.g. 4000<br>    ssh_key_file = string # e.g. ./users/test.pub<br>  }))</pre> | `[]` | no |
| <a name="input_subnet_tags"></a> [subnet\_tags](#input\_subnet\_tags) | Tags to discover target subnets in the VPC, these tags should identify one or more subnets | `map(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Common and mandatory tags for the resources | `map(string)` | `{}` | no |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | Tags to discover target VPC, these tags should uniquely identify a VPC | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_daily_report_subscribers"></a> [daily\_report\_subscribers](#output\_daily\_report\_subscribers) | Daily Report Subscribers |
| <a name="output_efs_ap"></a> [efs\_ap](#output\_efs\_ap) | EFS Access Point |
| <a name="output_sftp_iam_role"></a> [sftp\_iam\_role](#output\_sftp\_iam\_role) | IAM Roles used by SFTP Server |
| <a name="output_sftp_kms"></a> [sftp\_kms](#output\_sftp\_kms) | Outputs from KMS module |
| <a name="output_sftp_security_group"></a> [sftp\_security\_group](#output\_sftp\_security\_group) | Security Groups used by SFTP Server |
| <a name="output_sftp_server"></a> [sftp\_server](#output\_sftp\_server) | DNS name of the SFTP server |
| <a name="output_sftp_users"></a> [sftp\_users](#output\_sftp\_users) | SFTP Users |
| <a name="output_user_automation_subscribers"></a> [user\_automation\_subscribers](#output\_user\_automation\_subscribers) | User Automation Event Subscribers |
<!-- END_TF_DOCS -->
