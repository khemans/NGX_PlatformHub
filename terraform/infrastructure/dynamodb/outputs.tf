output "terraform_lock_table_name" {
  description = "Pass this value as dynamodb_table in every S3 backend.hcl for this account and region."
  value       = module.lock_table.table_name
}

output "terraform_lock_table_arn" {
  value = module.lock_table.table_arn
}
