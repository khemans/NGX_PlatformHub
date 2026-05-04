terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
      Layer       = "infrastructure"
      Component   = "s3-tfstate"
    }
  }
}

module "state_bucket" {
  source = "../../modules/s3_tfstate_bucket"

  bucket_name               = var.bucket_name
  enable_versioning         = var.enable_versioning
  force_destroy             = var.force_destroy
  deny_insecure_transport   = var.deny_insecure_transport
  prevent_destroy           = var.prevent_destroy

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}
