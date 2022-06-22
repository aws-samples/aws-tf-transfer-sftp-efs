/*---------------------------------------------------------
Provider Variable
---------------------------------------------------------*/
region = "us-east-1"

/*---------------------------------------------------------
Common Variables
---------------------------------------------------------*/
project  = "scenario2-efs"
env_name = "dev"
tags = {
  Env     = "DEV"
  Project = "scenario2-efs"
}

/*---------------------------------------------------------
Datasource Variables
---------------------------------------------------------*/
#Make sure that target VPC is identified uniquely via these tags
vpc_tags = {
  "transfer/sftp/efs" = "1"
  "Env"               = "DEV"
}

#Make sure that target subnets are tagged correctly
subnet_tags = {
  "transfer/sftp/efs" = "1"
  "Env"               = "DEV"
}

/*---------------------------------------------------------
EFS Variables
---------------------------------------------------------*/
kms_alias              = null
efs_id                 = null
security_group_tags    = null
efs_access_point_specs = []
