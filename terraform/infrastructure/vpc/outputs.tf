output "vpc_id" {
  description = "VPC ID (consumed by stacks via terraform_remote_state)."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_ids" {
  description = "NAT gateway IDs."
  value       = module.vpc.nat_gateway_ids
}
