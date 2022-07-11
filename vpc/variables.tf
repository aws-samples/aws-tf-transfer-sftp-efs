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

/*---------------------------------------------------------
VPC Variables
---------------------------------------------------------*/
variable "vpc_tags" {
  description = "Tags for the VPC"
  type        = map(string)
}

variable "vpc_public_subnet_tags" {
  description = "Tags for the public subnet"
  type        = map(string)
}

variable "vpc_private_subnet_tags" {
  description = "Tags for the private subnet"
  type        = map(string)
}

variable "r53_zone_names" {
  description = "Private Route53 Zone names to create and associate with the VPC"
  type        = list(string)
  default     = []
}
