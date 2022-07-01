module "common_efs" {
  source = "github.com/aws-samples/aws-tf-efs//modules/aws/efs?ref=v1.0.0"

  region = var.region

  project  = var.project
  env_name = var.env_name

  tags = var.tags

  vpc_tags    = var.vpc_tags
  subnet_tags = var.subnet_tags

  kms_alias       = var.kms_alias
  kms_admin_roles = ["Admin"]

  # If security_group_tags is null, EFS security group is created
  security_group_tags = var.security_group_tags

  efs_name         = "common"
  efs_id           = var.efs_id
  encrypted        = true
  performance_mode = "generalPurpose"
  transition_to_ia = "AFTER_7_DAYS"

  efs_tags = {
    "BackupPlan" = "EVERY-DAY"
  }

  efs_access_point_specs = var.efs_access_point_specs
}
