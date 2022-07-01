/*---------------------------------------------------------
Provider Variable
---------------------------------------------------------*/
region = "us-east-1"

/*---------------------------------------------------------
Common Variables
---------------------------------------------------------*/
project  = "scenario1-efs-sftp"
env_name = "dev"
tags = {
  Env     = "DEV"
  Project = "scenario1-efs-sftp"
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
kms_alias           = ""
efs_id              = null
security_group_tags = null
efs_access_point_specs = [
  {
    efs_name        = "common"
    efs_ap          = "sftp_scenario1"
    uid             = 0
    gid             = 0
    secondary_gids  = []
    root_path       = "/dev/scenario1-efs-sftp/sftp/common"
    owner_uid       = 0
    owner_gid       = 0
    root_permission = "0755"
    principal_arns  = ["*"]
  }
]
