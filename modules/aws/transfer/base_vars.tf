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
