/*---------------------------------------------------------
Provider Variable
---------------------------------------------------------*/
variable "region" {
  description = "The AWS Region e.g. us-east-1 for the environment"
  type        = string
}

/*---------------------------------------------------------
Common Variables
---------------------------------------------------------*/
variable "project" {
  description = "Project name (prefix/suffix) to be used on all the resources identification"
  type        = string
}

variable "env_name" {
  description = "Environment name e.g. dev, prod"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Common and mandatory tags for the resources"
  type        = map(string)
  default     = {}
}

/*---------------------------------------------------------
Datasource Variables
---------------------------------------------------------*/
variable "vpc_tags" {
  description = "Tags to discover target VPC, these tags should uniquely identify a VPC"
  type        = map(string)
}

variable "subnet_tags" {
  description = "Tags to discover target subnets in the VPC, these tags should identify one or more subnets"
  type        = map(string)
}

/*---------------------------------------------------------
SFTP Server Variables
---------------------------------------------------------*/
variable "kms_admin_roles" {
  description = "List Administrator roles for KMS, Provide at least one Admin role if create_kms is true"
  type        = list(string)
  default     = []
}

variable "create_common_logs" {
  description = "Create the common CW log groups and other common resources"
  type        = bool
  default     = false
}

variable "sftp_specs" {
  description = "Specs for the SFTP server"
  type = object({
    server_name = string #dns name compliant name prefix
    encryption = object({
      encrypt_logs     = bool   # default is false
      logs_kms_alias   = string # default is alias/{var.project}/logs
      encrypt_lambda   = bool   # default is false
      lambda_kms_alias = string # default is alias/{var.project}/lambda
      encrypt_sns      = bool   # default is false
      sns_kms_alias    = string # default is alias/{var.project}/sns
    })

    user_role    = string #if null, an IAM role for the SFTP user will be created
    logging_role = string #if null, an IAM role for the SFTP logging to CW will be created

    security_group = object({
      sftp_port    = number       #2049
      source_cidrs = list(string) #if [], the SFTP Security Group will not be created
      tags         = map(string)  #if provided, the identified SG will be attached
    })

    efs_specs = object({
      efs_id              = string      #if null, new EFS will be created
      efs_ap_id           = string      #if null, new EFS AP will be created
      security_group_tags = map(string) #if efs_id is not null, then it must be provided
      encryption          = bool
      kms_alias           = string
    })

    lambda_specs = object({
      execution_role                   = string      #if null, an IAM role for the SFTP User Automation Lambda will be created
      security_group_tags              = map(string) #if null, a Lambda security group will be created
      daily_report_schedule_expression = string      #e.g. cron(0 22 * * ? *)
    })
  })
}

variable "sftp_users" {
  description = "List of SFTP Users"
  type = list(object({
    name         = string # e.g. test1
    uid          = string # e.g. 3001
    gid          = string # e.g. 4000
    ssh_key_file = string # e.g. ./users/test.pub
  }))
  default = []
}

variable "sftp_user_automation_subscribers" {
  description = "List of email address to which user automation event outcome will be sent"
  type        = list(string)
  default     = []
}

variable "sftp_daily_report_subscribers" {
  description = "List of email address to which daily activity reports will be sent"
  type        = list(string)
  default     = []
}

/*---------------------------------------------------------
R53 Variables
---------------------------------------------------------*/
variable "r53_zone_name" {
  description = "Route 53 Zone basename, If not nulls R53 record will be created for the SFTP server"
  type        = string
  default     = null
}
