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
  description = "Project to be used on all the resources identification"
  type        = string
}

variable "env_name" {
  description = "Environment name e.g. dev, prod"
  type        = string
}

variable "tags" {
  description = "Mandatory tags for the resources"
  type        = map(string)
}

//---------------------------------------------------------//
// Bootstrap Variables
//---------------------------------------------------------//
variable "s3_statebucket_name" {
  description = "Globally unique name of the S3 bucket used for storing Terraform state files."
  type        = string
}

variable "dynamo_locktable_name" {
  description = "Name of the DynamoDB table used for Terraform state locking."
  type        = string
  default     = ""
}
