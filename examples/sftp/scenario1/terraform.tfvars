/*---------------------------------------------------------
Provider Variable
---------------------------------------------------------*/
region = "us-east-1"

/*---------------------------------------------------------
Common Variables
---------------------------------------------------------*/
project  = "scenario1-sftp"
env_name = "dev"
tags = {
  Env     = "DEV"
  Project = "scenario1-sftp"
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
SFTP Server Variables
---------------------------------------------------------*/
r53_zone_name = "your-r53-zone"
server_name   = "scenario1"

#sftp_encryptions = null
sftp_encryptions = {
  encrypt_logs     = true
  logs_kms_alias   = "" # kms will be created
  encrypt_lambda   = true
  lambda_kms_alias = null # kms will be created
  encrypt_sns      = true
  sns_kms_alias    = "" # kms will be created
}

create_common_logs = false

#Use existing EFS
efs_id = "your-efs-id"
#Use existing EFS AP
efs_ap_id = "your-efs-ap-id"
# Use existing EFS SG
efs_sg_tags = {
  Name = "scenario1-efs-sftp-common-efs-sg"
  Env  = "DEV"
}

#efs exists, so kms must exist
efs_kms_alias = "alias/scenario1-efs-sftp/efs"

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

#List of email addresses to receive user automation emails, recommend using group email
sftp_user_automation_subscribers = [
  "abc@xyz.com"
]

#List of email address to receive daily activity report, recommend using group email
sftp_daily_report_subscribers = [
  "abc@xyz.com",
]
