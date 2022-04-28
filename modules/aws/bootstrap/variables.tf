//---------------------------------------------------------//
// Provider Variable
//---------------------------------------------------------//
variable "region" {
  description = "The AWS Region e.g. us-east-1 for the environment"
  type        = string
}

//---------------------------------------------------------//
// Common Variables
//---------------------------------------------------------//
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

//---------------------------------------------------------//
// Bootstrap Variables
//---------------------------------------------------------//
variable "s3_statebucket_name" {
  description = "Name of the S3 bucket used for storing Terraform state files."
  type        = string
}

variable "dynamo_locktable_name" {
  description = "Name of the DynamoDB table used for Terraform state locking."
  type        = string
  default     = ""
}
