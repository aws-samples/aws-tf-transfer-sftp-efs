//---------------------------------------------------------//
// KMS Variables
//---------------------------------------------------------//
variable "kms_config" {
  description = "The requested KMS configuration"
  type = object({
    kms_admin_roles     = list(string) #Provide at least one Admin role for KMS
    kms_usage_roles     = list(string) #Zero or more roles that need access to KMS
    prefix              = string #e.g. {project}
    keys_to_create      = list(string) #provide at least one [efs,ebs,logs,sns,sqs,backup,ssm,secretsmanager,session,rds,kinesis,s3]
    enable_key_rotation = bool
  })
}
