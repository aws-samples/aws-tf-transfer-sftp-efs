//---------------------------------------------------------//
// Provider Variable
//---------------------------------------------------------//
region = "us-east-1"

//---------------------------------------------------------//
// Common Variables
//---------------------------------------------------------//
project  = "scenario3-sftp-efs"
env_name = "dev"
tags = {
  Env     = "DEV"
  Project = "scenario3-sftp-efs"
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
server_name   = "scenario3"

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

#Create new EFS
efs_id = null
#Create new EFS AP
efs_ap_id = null
# Create new EFS SG
efs_sg_tags = null

#create kms for EFS encryption
efs_kms_alias = ""

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
