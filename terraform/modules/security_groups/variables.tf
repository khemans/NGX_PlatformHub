variable "name_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "container_port" {
  type        = number
  description = "Container port exposed by the ECS service (default matches nginx image)."
  default     = 80
}

variable "alb_ingress_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed to reach the load balancer on HTTP."
  default     = ["0.0.0.0/0"]
}
