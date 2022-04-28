//---------------------------------------------------------//
// Datasource Variables
//---------------------------------------------------------//
variable "vpc_tags" {
  description = "Tags to discover target VPC, these tags should uniquely identify a VPC"
  type        = map(string)
}

variable "subnet_tags" {
  description = "Tags to discover target subnets in the VPC, these tags should identify one or more subnets"
  type        = map(string)
}

//---------------------------------------------------------//
// Elastic File System Variables
//---------------------------------------------------------//
variable "kms_alias" {
  description = "Use the given alias or create a new KMS like alias/{var.project}/efs"
  type        = string
  default     = ""
}

variable "kms_admin_roles" {
  description = "List Administrator roles for KMS, Provide at least one Admin role if create_kms is true"
  type        = list(string)
  default     = []
}

variable "efs_specs" {
  description = "List of EFS Specs"
  type = list(object({
    name                = string # unique name
    efs_id              = string # if null, new EFS will be created
    encrypted           = bool
    performance_mode    = string
    transition_to_ia    = string
    backup_plan         = string
    security_group_tags = map(string) # if null, new Security Group will be created
  }))
}

variable "efs_access_point_specs" {
  description = "List of EFS Access Point Specs."
  type = list(object({
    efs_name        = string # must match with any efs_specs.name
    efs_ap          = string # unique name
    uid             = number
    gid             = number
    root_path       = string # e.g. /{env}/{project}/{purpose}/{name}
    owner_uid       = number # e.g. 0
    owner_gid       = number # e.g. 0
    root_permission = string # e.g. 0755
  }))
  default = []
}

variable "efs_port" {
  description = "Ingress port for EFS"
  type        = number
  default     = 2049
}

