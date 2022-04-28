output "efs" {
  description = "Elastic File System info"
  value       = { for efs in local.efs : efs.name => efs }
}

output "efs_ap" {
  description = "Elastic File System Access Point info"
  value = { for efs_ap in aws_efs_access_point.efs_ap : efs_ap.tags["Name"] => {
    name           = efs_ap.tags["Name"]
    efs_id         = efs_ap.file_system_id
    efs_arn        = efs_ap.file_system_arn
    efs_ap_id      = efs_ap.id
    efs_ap_arn     = efs_ap.arn
    root_directory = efs_ap.root_directory[0].path
    }
  }
}

