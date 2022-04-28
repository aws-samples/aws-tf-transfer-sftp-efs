module "efs_kms" {
  source = "../kms"
  count = local.create_kms ? 1 : 0

  region = var.region

  project  = var.project
  env_name = var.env_name

  tags = var.tags

  kms_config = {
    kms_admin_roles = var.kms_admin_roles
    kms_usage_roles = []
    prefix          = var.project
    keys_to_create = [
      "efs",
      #   "ebs",
      #   "logs",
      #   "efs",
      #   "sns",
      #   "sqs",
      #   "backup",
      #   "ssm",
      #   "secretsmanager",
      #   "session",
      #   "rds",
      #   "kinesis",
      #   "s3"
    ]
    enable_key_rotation = false
  }
}

output "efs_kms" {
  description = "Outputs from KMS module forwarded"
  value       = [for kms in module.efs_kms : kms.key_aliases]
}
