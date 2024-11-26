terraform {
  # Store the Terraform state in an S3 bucket
  backend "s3" {
    # Intentionally blank - all parameters provided in command line
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.62"
    }
  }
}

# Setup AWS provider
provider "aws" {
  region = var.region
}