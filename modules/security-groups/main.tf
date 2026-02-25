# ─────────────────────────────────────────────
# ALB Security Group
# Accepts HTTPS from internet, HTTP redirect
# ─────────────────────────────────────────────
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-sg-alb"
  description = "ALB: accept HTTPS/HTTP from internet"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from internet (redirect to HTTPS)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-sg-alb"
  }
}

# ─────────────────────────────────────────────
# Backend (Node.js) Security Group
# Only accepts traffic from ALB
# ─────────────────────────────────────────────
resource "aws_security_group" "backend" {
  name        = "${var.project_name}-${var.environment}-sg-backend"
  description = "Backend: accept traffic from ALB only"
  vpc_id      = var.vpc_id

  ingress {
    description     = "From ALB"
    from_port       = var.backend_port
    to_port         = var.backend_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-sg-backend"
  }
}

# ─────────────────────────────────────────────
# Prometheus Security Group
# Accepts scrape requests from backend (internal)
# Accepts access from Grafana
# ─────────────────────────────────────────────
resource "aws_security_group" "prometheus" {
  name        = "${var.project_name}-${var.environment}-sg-prometheus"
  description = "Prometheus: internal access only"
  vpc_id      = var.vpc_id

  ingress {
    description = "Prometheus UI / API from VPC"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "Allow all outbound (scrape targets)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-sg-prometheus"
  }
}

# ─────────────────────────────────────────────
# Grafana Security Group
# Accepts traffic from ALB only
# ─────────────────────────────────────────────
resource "aws_security_group" "grafana" {
  name        = "${var.project_name}-${var.environment}-sg-grafana"
  description = "Grafana: accept from ALB only"
  vpc_id      = var.vpc_id

  ingress {
    description     = "From ALB"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-sg-grafana"
  }
}

# ─────────────────────────────────────────────
# RDS Security Group
# Only accepts connections from backend tasks
# ─────────────────────────────────────────────
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-sg-rds"
  description = "RDS: accept connections from backend only"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL from backend"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.backend.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-sg-rds"
  }
}

# ─────────────────────────────────────────────
# EFS Security Group
# Only accepts NFS from ECS private app subnets
# ─────────────────────────────────────────────
resource "aws_security_group" "efs" {
  name        = "${var.project_name}-${var.environment}-sg-efs"
  description = "EFS: NFS from ECS only"
  vpc_id      = var.vpc_id

  ingress {
    description     = "NFS from Prometheus task"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.prometheus.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-sg-efs"
  }
}

# ─────────────────────────────────────────────
# VPC Endpoint Security Group
# Interface endpoints need HTTPS from VPC
# ─────────────────────────────────────────────
resource "aws_security_group" "vpc_endpoints" {
  name        = "${var.project_name}-${var.environment}-sg-vpce"
  description = "VPC Interface Endpoints: HTTPS from VPC"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-sg-vpce"
  }
}
