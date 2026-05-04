output "alb_url" {
  description = "HTTP URL for the load-balanced ECS service."
  value       = "http://${module.ecs_fargate.load_balancer_dns_name}"
}

output "load_balancer_dns_name" {
  value = module.ecs_fargate.load_balancer_dns_name
}

output "ecs_cluster_name" {
  value = module.ecs_fargate.cluster_name
}

output "ecs_service_name" {
  value = module.ecs_fargate.service_name
}
