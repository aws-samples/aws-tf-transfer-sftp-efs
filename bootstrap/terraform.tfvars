//---------------------------------------------------------//
// Provider Variable
//---------------------------------------------------------//
region = "us-east-1"

//---------------------------------------------------------//
// Common Variables
//---------------------------------------------------------//
project  = "aws-tf-transfer-sftp-efs"
env_name = "dev"
tags = {
  Env     = "DEV"
  Project = "aws-tf-transfer-sftp-efs"
}

//---------------------------------------------------------//
// Bootstrap Variables
//---------------------------------------------------------//
s3_statebucket_name   = "aws-tf-transfer-sftp-efs-dev-terraform-state-bucket"
dynamo_locktable_name = "aws-tf-transfer-sftp-efs-dev-terraform-state-locktable"
