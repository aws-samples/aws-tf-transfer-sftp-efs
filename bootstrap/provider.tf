terraform {
  required_version = ">= v1.0.4"

  # Set minimum required versions for providers using lazy matching
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.2.0"
    }
  }

  # Configure the S3 backend
  # backend "s3" {
  #   encrypt        = true
  #   region         = "us-east-1"
  #   bucket         = "aws-tf-transfer-sftp-efs-dev-terraform-state-bucket"
  #   dynamodb_table = "aws-tf-transfer-sftp-efs-dev-terraform-state-locktable"
  #   key            = "bootstrap/terraform.tfstate"
  # }
}

# Configure the AWS Provider to assume_role and set default region
provider "aws" {
  region = var.region
}
