output "log_group_backend" { value = aws_cloudwatch_log_group.backend.name }
output "log_group_prometheus" { value = aws_cloudwatch_log_group.prometheus.name }
output "log_group_grafana" { value = aws_cloudwatch_log_group.grafana.name }
