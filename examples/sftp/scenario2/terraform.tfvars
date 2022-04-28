//---------------------------------------------------------//
// Provider Variable
//---------------------------------------------------------//
region = "us-east-1"

//---------------------------------------------------------//
// Common Variables
//---------------------------------------------------------//
project  = "scenario2-sftp"
env_name = "dev"
tags = {
  Env     = "DEV"
  Project = "scenario2-sftp"
}

//---------------------------------------------------------//
// Datasource Variables
//---------------------------------------------------------//
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

//---------------------------------------------------------//
// SFTP Server Variables
//---------------------------------------------------------//
r53_zone_name = "sftp.samples.aws"
server_name   = "scenario2"

#sftp_encryptions = null
sftp_encryptions = {
  encrypt_logs     = true
  logs_kms_alias   = ""
  encrypt_lambda   = true
  lambda_kms_alias = null
  encrypt_sns      = true
  sns_kms_alias    = "" #"alias/scenario1-sftp/sns"
}

create_common_logs = false

#Use existing EFS
efs_id = "fs-0012ff1e4f1946e6a"
#Create new EFS AP
efs_ap_id = null
# Use existing EFS SG
efs_sg_tags = {
  Name = "scenario2-efs-common-efs-sg"
  Env  = "DEV"
}

#efs exists, so kms must exist
efs_kms_alias = "alias/scenario2-efs/efs"

#create new roles
user_role    = null
logging_role = null
lambda_role  = null

sftp_users = [
  {
    "name"         = "test1"
    "uid"          = "3001"
    "gid"          = "4000"
    "ssh_key_file" = "./users/test.pub"
  },
  # {
  #   "name"         = "test2"
  #   "uid"          = "3002"
  #   "gid"          = "4000"
  #   "ssh_key_file" = "./users/test.pub"
  # },
  # {
  #   "name"         = "test3"
  #   "uid"          = "3003"
  #   "gid"          = "4000"
  #   "ssh_key_file" = "./users/test.pub"
  # }
]

sftp_user_automation_subscribers = [
  "vivgoyal@amazon.com"
]

sftp_daily_report_subscribers = [
  "vivgoyal@amazon.com",
]
