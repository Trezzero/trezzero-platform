output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.main.arn
}

output "load_balancer_url" {
  description = "The DNS name / URL of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "ALB zone id???"
  value       = aws_lb.main.zone_id
}

output "backend_target_group_arn" {
  description = "ARN of the ALB backend target group"
  value       = aws_lb_target_group.backend.arn
}


output "grafana_target_group_arn" {
  description = "ARN of the ALB Grafana target group"
  value       = aws_lb_target_group.grafana.arn
}

output "https_listener_arn" {
  description = "ARN of the listener"
  value       = aws_lb_listener.https.arn
}
