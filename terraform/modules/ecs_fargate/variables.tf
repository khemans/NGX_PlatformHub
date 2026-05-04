variable "name_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "alb_security_group_id" {
  type = string
}

variable "ecs_security_group_id" {
  type = string
}

variable "container_port" {
  type    = number
  default = 80
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "task_cpu" {
  type    = number
  default = 256
}

variable "task_memory" {
  type    = number
  default = 512
}

variable "app_secret_arn" {
  type        = string
  description = "Secrets Manager ARN for application secret (JSON key token)."
}

variable "db_host" {
  type        = string
  description = "Aurora writer endpoint hostname for application configuration."
  default     = ""
}

variable "container_image" {
  type        = string
  description = "Public container image (default nginx:alpine on port 80; no ECR auth required)."
  default     = "nginx:1.27-alpine"
}

variable "health_check_path" {
  type    = string
  default = "/"
}
