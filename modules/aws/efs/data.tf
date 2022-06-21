data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc" {
  tags = var.vpc_tags
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  tags = var.subnet_tags
}

data "aws_kms_key" "efs_cmk" {
  for_each = { for efs in var.efs_specs : efs.name => efs if try(efs.encrypted, false) == true }
  key_id   = local.kms_alias

  depends_on = [
    module.efs_kms
  ]
}
