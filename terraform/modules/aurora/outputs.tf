output "cluster_identifier" {
  value = aws_rds_cluster.this.cluster_identifier
}

output "cluster_endpoint" {
  value       = aws_rds_cluster.this.endpoint
  description = "Writer endpoint hostname."
}

output "cluster_reader_endpoint" {
  value = aws_rds_cluster.this.reader_endpoint
}

output "cluster_port" {
  value = aws_rds_cluster.this.port
}

output "master_user_secret_arn" {
  value       = one(aws_rds_cluster.this.master_user_secret).secret_arn
  description = "Secrets Manager ARN for the managed master user secret."
}

output "database_name" {
  value = aws_rds_cluster.this.database_name
}
