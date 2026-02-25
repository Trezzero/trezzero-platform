output "alb_arn" { value = aws_lb.main.arn }
output "alb_dns_name" { value = aws_lb.main.dns_name }
output "alb_zone_id" { value = aws_lb.main.zone_id }
output "backend_target_group_arn" { value = aws_lb_target_group.backend.arn }
output "grafana_target_group_arn" { value = aws_lb_target_group.grafana.arn }
output "https_listener_arn" { value = aws_lb_listener.https.arn }
