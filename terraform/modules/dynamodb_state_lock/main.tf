# Terraform S3 backend requires a DynamoDB table with partition key LockID (String).
# See: https://developer.hashicorp.com/terraform/language/settings/backends/s3

resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = var.table_name
  billing_mode = var.billing_mode
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }

  tags = merge(
    {
      Name        = var.table_name
      Purpose     = "terraform-state-lock"
      ManagedBy   = "terraform"
    },
    var.tags,
  )
}
