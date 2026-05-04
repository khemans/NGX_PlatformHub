variable "name_prefix" {
  type = string
}

variable "recovery_window_in_days" {
  type        = number
  description = "Secrets Manager recovery window. Use 0 for immediate delete in lab accounts."
  default     = 7
}

variable "app_secret_description" {
  type    = string
  default = "Application-level secret material for ECS tasks (non-database)."
}
