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
      Stack       = "security_groups"
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

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "security_groups" {
  source = "../../modules/security_groups"

  name_prefix        = local.name_prefix
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  container_port     = var.container_port
  alb_ingress_cidrs  = var.alb_ingress_cidrs
}
