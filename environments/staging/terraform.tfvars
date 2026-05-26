# ─────────────────────────────────────────────
# Staging Environment — cheaper, no Multi-AZ
# ─────────────────────────────────────────────

project_name                    = "trezzero"
environment                     = "staging"
aws_region                      = "af-south-1"

# VPC — separate CIDR from prod to avoid overlap
vpc_cidr                        = "10.1.0.0/16"
availability_zones              = ["af-south-1a", "af-south-1b"]
public_subnet_cidrs             = ["10.1.1.0/24", "10.1.2.0/24"]
private_app_subnet_cidrs        = ["10.1.11.0/24", "10.1.12.0/24"]
private_db_subnet_cidrs         = ["10.1.21.0/24", "10.1.22.0/24"]

# ECS Backend — reduced for staging
backend_ecr_repository_name     = "myapp-backend"
backend_ecr_image_tag           = "staging"
backend_cpu                     = 256
backend_memory                  = 512
backend_desired_count           = 1
backend_min_count               = 1
backend_max_count               = 3
backend_port                    = 3000

# Prometheus
prometheus_cpu                  = 256
prometheus_memory               = 512

# Grafana
grafana_cpu                     = 256
grafana_memory                  = 512

# RDS — single-AZ for staging
rds_instance_class              = "db.t4g.micro"
rds_allocated_storage           = 10
rds_max_allocated_storage       = 50
rds_db_name                     = "trezzero_staging"
rds_multi_az                    = false

# DNS
domain_name                     = "example.com"
subdomain                       = "api-staging"
certificate_arn                 = "arn:aws:acm:af-south-1:123456789:certificate/xxxx-xxxx"

# CloudWatch — 5 days
log_retention_days              = 5
