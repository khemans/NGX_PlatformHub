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
      Stack       = "aurora"
    }
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.terraform_state_bucket
    key    = "${var.terraform_state_prefix}/vpc/terraform.tfstate"
    region = var.terraform_state_region
  }
}

data "terraform_remote_state" "security_groups" {
  backend = "s3"

  config = {
    bucket = var.terraform_state_bucket
    key    = "${var.terraform_state_prefix}/security_groups/terraform.tfstate"
    region = var.terraform_state_region
  }
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "aurora" {
  source = "../../modules/aurora"

  name_prefix            = local.name_prefix
  private_subnet_ids     = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  vpc_security_group_ids = [data.terraform_remote_state.security_groups.outputs.aurora_security_group_id]
  engine_version         = var.aurora_engine_version
  skip_final_snapshot    = var.aurora_skip_final_snapshot
}
