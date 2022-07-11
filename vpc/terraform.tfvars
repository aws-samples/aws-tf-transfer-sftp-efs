/*---------------------------------------------------------
Provider Variable
---------------------------------------------------------*/
region = "us-east-1"

/*---------------------------------------------------------
Common Variables
---------------------------------------------------------*/
project  = "aws-tf-transfer-sftp-efs-vpc"
env_name = "dev"
tags = {
  Env     = "DEV"
  Project = "aws-tf-transfer-sftp-efs-vpc"
}

/*---------------------------------------------------------
VPC Variables
---------------------------------------------------------*/
vpc_tags = {
  "transfer/sftp/efs" = "1"
  "Env"               = "DEV"
}

vpc_public_subnet_tags = {}

vpc_private_subnet_tags = {
  "transfer/sftp/efs" = "1"
  "Env"               = "DEV"
}

r53_zone_names = ["<your-r53-zone>"]
