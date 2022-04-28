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

data "aws_kms_key" "logs_cmk" {
  count = local.encrypt_logs ? 1 : 0

  key_id = local.logs_kms_alias

  depends_on = [
    module.transfer_kms
  ]
}

data "aws_kms_key" "lambda_cmk" {
  count = local.encrypt_lambda ? 1 : 0

  key_id = local.lambda_kms_alias

  depends_on = [
    module.transfer_kms
  ]
}

data "aws_kms_key" "sns_cmk" {
  count = local.encrypt_sns ? 1 : 0

  key_id = local.sns_kms_alias

  depends_on = [
    module.transfer_kms
  ]
}

data "aws_efs_file_system" "sftp_efs" {
  file_system_id = local.efs.efs_id
}

data "aws_efs_access_point" "sftp_efs_ap" {
  access_point_id = local.efs.efs_ap_id
}

data "aws_route53_zone" "pvt_zone" {
  count = local.create_r53_record ? 1 : 0

  name         = var.r53_zone_name
  vpc_id       = data.aws_vpc.vpc.id
  private_zone = true
}
