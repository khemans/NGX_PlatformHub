output "alb_security_group_id" {
  description = "ALB security group ID."
  value       = module.security_groups.alb_security_group_id
}

output "ecs_tasks_security_group_id" {
  description = "ECS task ENI security group ID."
  value       = module.security_groups.ecs_tasks_security_group_id
}

output "aurora_security_group_id" {
  description = "Aurora security group ID."
  value       = module.security_groups.aurora_security_group_id
}
