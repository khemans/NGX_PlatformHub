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
      Stack       = "ecs_fargate"
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

data "terraform_remote_state" "secrets" {
  backend = "s3"

  config = {
    bucket = var.terraform_state_bucket
    key    = "${var.terraform_state_prefix}/secrets/terraform.tfstate"
    region = var.terraform_state_region
  }
}

data "terraform_remote_state" "aurora" {
  backend = "s3"

  config = {
    bucket = var.terraform_state_bucket
    key    = "${var.terraform_state_prefix}/aurora/terraform.tfstate"
    region = var.terraform_state_region
  }
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "ecs_fargate" {
  source = "../../modules/ecs_fargate"

  name_prefix             = local.name_prefix
  vpc_id                  = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnet_ids       = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  private_subnet_ids      = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  alb_security_group_id   = data.terraform_remote_state.security_groups.outputs.alb_security_group_id
  ecs_security_group_id   = data.terraform_remote_state.security_groups.outputs.ecs_tasks_security_group_id
  app_secret_arn          = data.terraform_remote_state.secrets.outputs.app_secret_arn
  db_host                 = data.terraform_remote_state.aurora.outputs.cluster_endpoint
  desired_count           = var.ecs_desired_count
  container_image         = var.container_image
  container_port          = var.container_port
}
