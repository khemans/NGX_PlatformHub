terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
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
      Stack       = "secrets"
    }
  }
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "secrets" {
  source = "../../modules/secrets"

  name_prefix             = local.name_prefix
  recovery_window_in_days = var.secrets_recovery_window_in_days
}
