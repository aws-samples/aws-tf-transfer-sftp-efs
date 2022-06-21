locals {
  create_kms = try(length(var.kms_alias), 0) != 0 ? false : true
  kms_alias  = try(length(var.kms_alias), 0) != 0 ? var.kms_alias : "alias/${var.project}/efs"
}
