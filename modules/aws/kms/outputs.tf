output "key_aliases" {
  description = "KMS key aliases that are created"
  value       = [for alias in aws_kms_alias.kms_alias : alias.name]
}