module "bootstrap" {
  source = "../modules/aws/bootstrap"

  region = var.region

  project  = var.project
  env_name = var.env_name

  tags = var.tags

  s3_statebucket_name   = var.s3_statebucket_name
  dynamo_locktable_name = var.dynamo_locktable_name
}

output "backend_config" {
  description = "Define the backend configuration with following values"
  value       = module.bootstrap.backend_config
}
