output "table_name" {
  description = "Table name for S3 backend dynamodb_table= argument."
  value       = aws_dynamodb_table.terraform_state_lock.name
}

output "table_arn" {
  description = "DynamoDB table ARN."
  value       = aws_dynamodb_table.terraform_state_lock.arn
}

output "table_id" {
  value = aws_dynamodb_table.terraform_state_lock.id
}
