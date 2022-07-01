module "transfer_kms" {
  source = "github.com/aws-samples/aws-tf-kms//modules/aws/kms?ref=v1.0.0"
  count  = local.create_kms ? 1 : 0

  region = var.region

  project  = var.project
  env_name = var.env_name

  tags = var.tags

  kms_alias_prefix = var.project
  kms_admin_roles  = var.kms_admin_roles
  kms_usage_roles  = []

  enable_kms_lambda = local.create_lambda_kms_alias
  enable_kms_logs   = local.create_logs_kms_alias
  enable_kms_sns    = local.create_sns_kms_alias
}

module "transfer_efs" {
  source = "github.com/aws-samples/aws-tf-efs//modules/aws/efs?ref=v1.0.0"
  count  = local.create_efs ? 1 : 0

  region = var.region

  project  = var.project
  env_name = var.env_name

  tags = var.tags

  #Make sure that target VPC is identified uniquely via these tags
  vpc_tags = var.vpc_tags

  #Make sure that target subnets are tagged correctly
  subnet_tags = var.subnet_tags

  security_group_tags = var.sftp_specs.efs_specs.efs_id != null ? null : var.sftp_specs.efs_specs.security_group_tags

  #create kms only if EFS is being created
  kms_alias       = var.sftp_specs.efs_specs.kms_alias
  kms_admin_roles = var.kms_admin_roles

  efs_name         = "transfer-${var.sftp_specs.server_name}"
  efs_id           = var.sftp_specs.efs_specs.efs_id
  encrypted        = var.sftp_specs.efs_specs.encryption
  performance_mode = "generalPurpose"
  transition_to_ia = "AFTER_7_DAYS"

  efs_tags = {
    "BackupPlan" = "EVERY-DAY"
  }

  efs_access_point_specs = [
    {
      efs_name        = "transfer-${var.sftp_specs.server_name}"
      efs_ap          = "${var.sftp_specs.server_name}_ap"
      uid             = 0
      gid             = 0
      secondary_gids  = []
      root_path       = "/${var.env_name}/${var.project}/sftp/${var.sftp_specs.server_name}"
      owner_uid       = 0
      owner_gid       = 0
      root_permission = "0755"
      principal_arns  = ["*"]
    }
  ]
}
