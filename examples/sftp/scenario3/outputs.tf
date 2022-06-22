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
