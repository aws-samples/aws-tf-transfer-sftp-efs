module "efs_kms" {
  source = "github.com/aws-samples/aws-tf-kms//modules/aws/kms"
  count  = local.create_kms ? 1 : 0

  region = var.region

  project  = var.project
  env_name = var.env_name

  tags = var.tags

  kms_alias_prefix = var.project
  kms_admin_roles  = var.kms_admin_roles
  kms_usage_roles  = []

  enable_kms_efs = true
}

output "efs_kms" {
  description = "Outputs from KMS module forwarded"
  value       = [for kms in module.efs_kms : kms.key_aliases]
}
