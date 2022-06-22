module "bootstrap" {
  source = "../modules/aws/bootstrap"

  region = var.region

  tags = var.tags

  s3_statebucket_name   = var.s3_statebucket_name
  dynamo_locktable_name = var.dynamo_locktable_name
}
