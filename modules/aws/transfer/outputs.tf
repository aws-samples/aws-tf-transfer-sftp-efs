output "sftp_server" {
  description = "DNS name of the SFTP server"
  value       = [for r53_rec in aws_route53_record.sftp_rec : r53_rec.fqdn]
}

output "sftp_iam_role" {
  description = "IAM Roles used by SFTP Server"
  value = {
    sftp_logging_role = data.aws_iam_role.transfer_logging.arn
    sftp_user_role    = data.aws_iam_role.transfer_user.arn
    sftp_lambda_role  = data.aws_iam_role.sftp_lambda.arn
  }
}

output "sftp_security_group" {
  description = "Security Groups used by SFTP Server"
  value = {
    sftp_sg     = data.aws_security_group.sftp_sg.id
    sftp_efs_sg = data.aws_security_group.sftp_efs.id
    lambda_sg   = data.aws_security_group.lambda_sg.id
  }
}

output "efs_ap" {
  description = "EFS Access Point"
  value = {
    efs_id         = data.aws_efs_access_point.sftp_efs_ap.file_system_id
    efs_arn        = data.aws_efs_access_point.sftp_efs_ap.file_system_arn
    efs_ap_id      = data.aws_efs_access_point.sftp_efs_ap.id
    efs_ap_arn     = data.aws_efs_access_point.sftp_efs_ap.arn
    root_directory = data.aws_efs_access_point.sftp_efs_ap.root_directory[0].path
  }
}

output "sftp_users" {
  description = "SFTP Users"
  value       = [for user in aws_transfer_user.sftp_user : user.user_name]
}

output "daily_report_subscribers" {
  description = "Daily Report Subscribers"
  value       = [for sub in aws_sns_topic_subscription.sftp_daily_report : sub.endpoint]
}

output "user_automation_subscribers" {
  description = "User Automation Event Subscribers"
  value       = [for sub in aws_sns_topic_subscription.sftp_lambda : sub.endpoint]
}
