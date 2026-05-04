output "cluster_identifier" {
  value = module.aurora.cluster_identifier
}

output "cluster_endpoint" {
  description = "Writer endpoint hostname."
  value       = module.aurora.cluster_endpoint
  sensitive   = true
}

output "cluster_reader_endpoint" {
  value = module.aurora.cluster_reader_endpoint
}

output "cluster_port" {
  value = module.aurora.cluster_port
}

output "master_user_secret_arn" {
  description = "Secrets Manager ARN for the RDS-managed master user."
  value       = module.aurora.master_user_secret_arn
  sensitive   = true
}

output "database_name" {
  value = module.aurora.database_name
}
