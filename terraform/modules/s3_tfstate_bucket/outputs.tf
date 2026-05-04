output "bucket_id" {
  description = "S3 bucket name (use as backend bucket=)."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}

output "bucket_region" {
  description = "AWS region where the bucket was created (must match backend region=)."
  value       = data.aws_region.current.name
}
