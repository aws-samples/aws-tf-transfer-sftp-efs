module "common_efs" {
  source = "../../../modules/aws/efs"

  region = var.region

  project  = var.project
  env_name = var.env_name

  tags = var.tags

  vpc_tags    = var.vpc_tags
  subnet_tags = var.subnet_tags

  kms_alias    = var.kms_alias
  kms_admin_roles = ["Admin"]

  efs_specs = [
    {
      name             = "common"
      efs_id           = var.efs_id
      encrypted        = true
      performance_mode = "generalPurpose"
      transition_to_ia = "AFTER_7_DAYS"
      backup_plan      = "EVERY-DAY"
      # If security_group_tags is null, EFS security group is created
      security_group_tags = var.security_group_tags
    }
  ]

  efs_access_point_specs = var.efs_access_point_specs
}

output "efs" {
  description = "Elastic File System info"
  value       = module.common_efs.efs
}

output "efs_ap" {
  description = "Elastic File System Access Points"
  value       = module.common_efs.efs_ap
}

output "efs_kms" {
  description = "KMS Keys created for EFS"
  value       = module.common_efs.efs_kms
}
