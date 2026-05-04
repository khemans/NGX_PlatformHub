variable "name_prefix" {
  type = string
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets for the DB subnet group."
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "database_name" {
  type    = string
  default = "platform"
}

variable "master_username" {
  type    = string
  default = "clusteradmin"
}

variable "engine_version" {
  type    = string
  default = "15.8"
}

variable "serverless_min_capacity" {
  type    = number
  default = 0.5
}

variable "serverless_max_capacity" {
  type    = number
  default = 2
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Set false for production workloads that require a final snapshot on destroy."
  default     = true
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "backup_retention_period" {
  type    = number
  default = 7
}
