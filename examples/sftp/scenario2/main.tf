module "sftp" {
  source = "../../../modules/aws/transfer"

  region = var.region

  project  = var.project
  env_name = var.env_name

  tags = var.tags

  vpc_tags    = var.vpc_tags
  subnet_tags = var.subnet_tags

  r53_zone_name = var.r53_zone_name

  kms_admin_roles    = ["Admin"]
  create_common_logs = var.create_common_logs

  sftp_specs = {
    server_name = var.server_name
    encryption  = var.sftp_encryptions
    #if sftp_user_role is not specified, it will be created
    user_role = var.user_role
    #if sftp_logging_role is not specified, it will be created
    logging_role = var.logging_role

    security_group = {
      sftp_port = 22
      source_cidrs = [
        "0.0.0.0/0"
      ]
      tags = {
        "Name"    = "${var.project}-${var.server_name}-sftp-sg"
        "Env"     = "DEV"
        "Project" = var.project
      }
    }

    efs_specs = {
      #if efs_id is null, EFS will be created
      efs_id = var.efs_id
      #if efs_ap_id is null, or efs_id is null the EFS access point will be created
      efs_ap_id = var.efs_ap_id

      #if security_group_tags are provided, a uniquely identified SG must exist
      #if efs_id is not null then security_group_tags must be provided
      #security rule will be added for allowing access from Lambda SG
      security_group_tags = var.efs_sg_tags

      #if security_group_tags is null, security group is created
      #security_group_tags = null

      encryption = true
      kms_alias  = var.efs_kms_alias
    }

    lambda_specs = {
      #if execution_role is not specified, it will be created
      execution_role = var.lambda_role
      #if security_group_tags is not specified, it will be created
      security_group_tags              = null
      daily_report_schedule_expression = "cron(0 22 * * ? *)"
    }
  }

  sftp_users                       = var.sftp_users
  sftp_user_automation_subscribers = var.sftp_user_automation_subscribers
  sftp_daily_report_subscribers    = var.sftp_daily_report_subscribers
}

output "sftp_server" {
  description = "Route 53 FQDN for SFTP Server"
  value       = module.sftp.sftp_server
}

output "sftp_iam_role" {
  description = "IAM Roles used by SFTP"
  value       = module.sftp.sftp_iam_role
}

output "sftp_kms" {
  description = "KMS Keys created by SFTP"
  value       = module.sftp.sftp_kms
}

output "sftp_security_group" {
  description = "Security Group used by SFTP Server"
  value       = module.sftp.sftp_security_group
}

output "sftp_efs_ap" {
  description = "Elastic File System ids"
  value       = module.sftp.efs_ap
}

output "sftp_users" {
  description = "SFTP Users"
  value       = module.sftp.sftp_users
}

output "daily_report_subscribers" {
  description = "Daily Report Subscribers"
  value       = module.sftp.daily_report_subscribers
}

output "user_automation_subscribers" {
  description = "User Automation Event Subscribers"
  value       = module.sftp.user_automation_subscribers
}
