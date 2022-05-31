module "transfer_kms" {
  source = "github.com/aws-samples/aws-tf-kms//modules/aws/kms"
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

output "sftp_kms" {
  description = "Outputs from KMS module"
  value       = [for kms in module.transfer_kms : kms.key_aliases]
}

module "transfer_efs" {
  source = "../efs"
  count  = local.create_efs ? 1 : 0

  region = var.region

  project  = var.project
  env_name = var.env_name

  tags = var.tags

  #Make sure that target VPC is identified uniquely via these tags
  vpc_tags = var.vpc_tags

  #Make sure that target subnets are tagged correctly
  subnet_tags = var.subnet_tags

  #create kms only if EFS is being created
  kms_alias       = var.sftp_specs.efs_specs.kms_alias
  kms_admin_roles = var.kms_admin_roles

  efs_specs = [
    {
      name = "transfer-${var.sftp_specs.server_name}"
      #if efs_id is null, EFS will be created
      efs_id              = var.sftp_specs.efs_specs.efs_id
      encrypted           = var.sftp_specs.efs_specs.encryption
      performance_mode    = "generalPurpose"
      transition_to_ia    = "AFTER_7_DAYS"
      backup_plan         = "EVERY-DAY"
      security_group_tags = var.sftp_specs.efs_specs.security_group_tags
    }
  ]

  efs_access_point_specs = [
    {
      efs_name        = "transfer-${var.sftp_specs.server_name}"
      efs_ap          = "${var.sftp_specs.server_name}_ap"
      uid             = 0
      gid             = 0
      root_path       = "/${var.env_name}/${var.project}/sftp/${var.sftp_specs.server_name}"
      owner_uid       = 0
      owner_gid       = 0
      root_permission = "0755"
    }
  ]
}

