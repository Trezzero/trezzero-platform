output "cluster_name" { value = aws_ecs_cluster.main.name }
output "cluster_arn" { value = aws_ecs_cluster.main.arn }
output "backend_service_name" { value = aws_ecs_service.backend.name }
output "prometheus_service_name" { value = aws_ecs_service.prometheus.name }
output "grafana_service_name" { value = aws_ecs_service.grafana.name }
output "service_discovery_namespace_id" { value = aws_service_discovery_private_dns_namespace.main.id }
