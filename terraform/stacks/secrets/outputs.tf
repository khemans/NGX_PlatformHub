output "app_secret_arn" {
  description = "Application secret ARN (JSON key token)."
  value       = module.secrets.app_secret_arn
}

output "app_secret_name" {
  description = "Secrets Manager secret name."
  value       = module.secrets.app_secret_name
}
