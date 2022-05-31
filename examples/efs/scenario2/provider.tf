terraform {

  # Set minimum required versions for providers using lazy matching
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.2.0"
    }
  }

  # Configure the S3 backend
  backend "s3" {
    encrypt        = true
    bucket         = "aws-tf-transfer-sftp-efs-dev-terraform-state-bucket"
    region         = "us-east-1"
    dynamodb_table = "aws-tf-transfer-sftp-efs-dev-terraform-state-locktable"
    key            = "aws-tf-transfer-sftp-efs/scenario2/efs/terraform.tfstate"
  }
}

# Configure the AWS Provider to assume_role and set default region
provider "aws" {
  region = var.region
}
