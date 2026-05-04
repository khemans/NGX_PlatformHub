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
      Component   = "dynamodb-state-lock"
    }
  }
}

module "lock_table" {
  source = "../../modules/dynamodb_state_lock"

  table_name                     = var.table_name
  billing_mode                   = var.billing_mode
  point_in_time_recovery_enabled = var.point_in_time_recovery_enabled

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}
