output "alb_sg_id" { value = aws_security_group.alb.id }
output "backend_sg_id" { value = aws_security_group.backend.id }
output "prometheus_sg_id" { value = aws_security_group.prometheus.id }
output "grafana_sg_id" { value = aws_security_group.grafana.id }
output "rds_sg_id" { value = aws_security_group.rds.id }
output "efs_sg_id" { value = aws_security_group.efs.id }
output "vpc_endpoints_sg_id" { value = aws_security_group.vpc_endpoints.id }
