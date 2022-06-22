terraform {
  required_version = ">= v1.1.9"
  # Set minimum required versions for providers using lazy matching
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.13.0"
    }
  }

  # Configure the S3 backend
  backend "s3" {
    encrypt        = true
    bucket         = "aws-tf-transfer-sftp-efs-dev-terraform-state-bucket"
    region         = "us-east-1"
    dynamodb_table = "aws-tf-transfer-sftp-efs-dev-terraform-state-locktable"
    key            = "aws-tf-transfer-sftp-efs/scenario2/transfer/terraform.tfstate"
  }
}

# Configure the AWS Provider to assume_role and set default region
provider "aws" {
  region = var.region
}
