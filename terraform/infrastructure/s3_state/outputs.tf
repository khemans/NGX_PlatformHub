output "state_bucket_id" {
  description = "Set terraform_state_bucket in env *.remote_state.tfvars to this value."
  value       = module.state_bucket.bucket_id
}

output "state_bucket_arn" {
  value = module.state_bucket.bucket_arn
}

output "state_bucket_region" {
  description = "Must match backend region= for every root using this bucket."
  value       = module.state_bucket.bucket_region
}
