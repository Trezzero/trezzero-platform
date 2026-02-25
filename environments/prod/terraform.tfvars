# ─────────────────────────────────────────────
# Production Environment
# ─────────────────────────────────────────────

project_name = "trezzero"
environment  = "prod"
aws_region   = "af-south-1"

# VPC
vpc_cidr                 = "10.0.0.0/16"
availability_zones       = ["af-south-1a", "af-south-1b"]
public_subnet_cidrs      = ["10.0.1.0/24", "10.0.2.0/24"]
private_app_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
private_db_subnet_cidrs  = ["10.0.21.0/24", "10.0.22.0/24"]

# ECS Backend
backend_ecr_repository_name = "myapp-backend"
backend_ecr_image_tag       = "latest"
backend_cpu           = 512
backend_memory        = 1024
backend_desired_count = 2
backend_min_count     = 2
backend_max_count     = 8
backend_port          = 3000

# Prometheus
prometheus_cpu    = 256
prometheus_memory = 512

# Grafana
grafana_cpu    = 256
grafana_memory = 512

# RDS
rds_instance_class        = "db.t4g.small"
rds_allocated_storage     = 20
rds_max_allocated_storage = 100
rds_db_name               = "myapp_prod"
rds_multi_az              = true

# DNS
domain_name     = "example.com"
subdomain       = "api"
certificate_arn = "arn:aws:acm:af-south-1:123456789:certificate/xxxx-xxxx"

# CloudWatch — 5 days only
log_retention_days = 5

# Sensitive values — use TF_VAR_* env vars or a secrets backend
# rds_username           = set via TF_VAR_rds_username
# rds_password           = set via TF_VAR_rds_password
# grafana_admin_password = set via TF_VAR_grafana_admin_password
