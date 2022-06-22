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
}

variable "tags" {
  description = "Common and mandatory tags for the resources"
  type        = map(string)
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
variable "server_name" {
  description = "DNS compliant name, unique, SFTP Server Name"
  type        = string
}

variable "r53_zone_name" {
  description = "Route 53 Zone Name. Optional, if provided, a DNS record will be created for the SFTP server"
  type        = string
  default     = ""
}

variable "sftp_encryptions" {
  description = "Encryption specs for the SFTP server"
  type = object({
    encrypt_logs     = bool   # default false
    logs_kms_alias   = string # new CMK will be created, if needed
    encrypt_lambda   = bool   # default false
    lambda_kms_alias = string # new CMK will be created, if needed
    encrypt_sns      = bool   # default false
    sns_kms_alias    = string # new CMK will be created, if needed
  })
  default = null
}

variable "create_common_logs" {
  description = "Create the common CW log groups"
  type        = bool
  default     = false
}

variable "efs_id" {
  description = "EFS File System Id, if not provided a new EFS will be created"
  type        = string
  default     = null
}

variable "efs_ap_id" {
  description = "EFS File System Access Point Id, if not provided a new EFA Access Point will be created"
  type        = string
  default     = null
}

variable "efs_sg_tags" {
  description = "Tags used to discover EFS Security Group, if not provided new EFS security group will be created. If efs_id is provided, this must also be provided."
  type        = map(string)
  default     = null
}


variable "efs_kms_alias" {
  description = "KMS Alias to discover KMS for EFS encryption, if not provided a new CMK will be created. If efs_id is provided for the encrypted EFS, this must also be provided."
  type        = string
  default     = ""
}

variable "sftp_users" {
  description = "List of SFTP Users with POSIX profile and ssh key file"
  type = list(object({
    name         = string # unique name
    uid          = string # e.g. 3001
    gid          = string # e.g. 4000
    ssh_key_file = string # e.g. ./users/test.pub
  }))
}

variable "sftp_user_automation_subscribers" {
  description = "List of email address to user automation information will be sent"
  type        = list(string)
  default     = []
}

variable "sftp_daily_report_subscribers" {
  description = "List of email address to which daily activity reports will be sent"
  type        = list(string)
  default     = []
}

variable "user_role" {
  description = "SFTP User Role, if not provided a new IAM role will be created"
  type        = string
  default     = null
}

variable "logging_role" {
  description = "SFTP Logging Role, if not provided a new IAM role will be created"
  type        = string
  default     = null
}

variable "lambda_role" {
  description = "Lambda Execution Role, if not provided a new IAM role will be created"
  type        = string
  default     = null
}
