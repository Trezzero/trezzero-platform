output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "cluster_arn" {
  description = "ECS Cluster arn"
  value       = aws_ecs_cluster.main.arn
}

output "backend_service_name" {
  description = "Name of the backend app ECS service"
  value       = aws_ecs_service.backend.name
}

output "prometheus_service_name" {
  description = "Name of the promethues ECS service"
  value       = aws_ecs_service.prometheus.name
}

output "grafana_service_name" {
  description = "Name of the grafana ECS service"
  value       = aws_ecs_service.grafana.name
}

output "service_discovery_namespace_id" {
  description = "Internal service discovery for trezzero staging"
  value       = aws_service_discovery_private_dns_namespace.main.id
}
