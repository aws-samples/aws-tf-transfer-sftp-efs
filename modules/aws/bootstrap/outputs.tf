output "backend_config" {
  description = "Define the backend configuration with following values"
  value       = <<-EOT
bucket = "${aws_s3_bucket.tfstate.id}"
dynamodb_table = "${var.dynamo_locktable_name}"
region = "${var.region}"
#key = "create-your-own-key-here"
EOT
}
