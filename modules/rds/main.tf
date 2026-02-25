# ─────────────────────────────────────────────
# DB Subnet Group
# ─────────────────────────────────────────────
resource "aws_db_subnet_group" "main" {
  name        = "${var.project_name}-${var.environment}-db-subnet-group"
  description = "DB subnet group for ${var.project_name} ${var.environment}"
  subnet_ids  = var.private_db_subnet_ids

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}

# ─────────────────────────────────────────────
# DB Parameter Group
# PostgreSQL tuning for a small t4g instance
# ─────────────────────────────────────────────
resource "aws_db_parameter_group" "main" {
  name        = "${var.project_name}-${var.environment}-pg16"
  family      = "postgres16"
  description = "Custom parameter group for ${var.project_name}"

  # Connection & memory settings appropriate for t4g.small (2GB RAM)
  parameter {
    name  = "max_connections"
    value = "200"
  }

  parameter {
    name  = "shared_buffers"
    value = "256000" # ~256MB in 8kB pages (INTVAL)
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "work_mem"
    value = "4096" # 4MB per sort/hash operation
  }

  parameter {
    name  = "maintenance_work_mem"
    value = "65536" # 64MB for VACUUM, index builds
  }

  parameter {
    name  = "effective_cache_size"
    value = "1572864" # ~1.5GB
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "1000" # Log queries slower than 1s
  }

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  parameter {
    name  = "log_lock_waits"
    value = "1"
  }

  parameter {
    name  = "idle_in_transaction_session_timeout"
    value = "30000" # 30s — kill idle-in-tx connections
  }

  parameter {
    name  = "statement_timeout"
    value = "30000" # 30s hard limit per statement
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-pg-params"
  }
}

# ─────────────────────────────────────────────
# Secrets Manager — store DB credentials
# ─────────────────────────────────────────────
resource "aws_secretsmanager_secret" "db" {
  name        = "${var.project_name}/${var.environment}/db-credentials"
  description = "RDS credentials for ${var.project_name} ${var.environment}"

  tags = {
    Name = "${var.project_name}-${var.environment}-db-secret"
  }
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    username = var.username
    password = var.password
    dbname   = var.db_name
    host     = aws_db_instance.main.address
    port     = aws_db_instance.main.port
    engine   = "postgres"
  })

  depends_on = [aws_db_instance.main]
}

# ─────────────────────────────────────────────
# RDS PostgreSQL Instance
# ─────────────────────────────────────────────
resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-${var.environment}-postgres"

  # Engine
  engine               = "postgres"
  engine_version       = "16.3"
  instance_class       = var.instance_class

  # Storage — gp3 for better price/perf than gp2
  storage_type          = "gp3"
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage # Enables autoscaling
  storage_encrypted     = true

  # Credentials
  db_name  = var.db_name
  username = var.username
  password = var.password

  # Network
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_security_group_id]
  publicly_accessible    = false

  # HA
  multi_az = var.multi_az

  # Parameter / option groups
  parameter_group_name = aws_db_parameter_group.main.name

  # Backups
  backup_retention_period   = 7       # 7 days
  backup_window             = "03:00-04:00"
  maintenance_window        = "sun:04:00-sun:05:00"
  copy_tags_to_snapshot     = true
  delete_automated_backups  = false

  # Monitoring — basic only (no enhanced monitoring to save cost)
  monitoring_interval = 0

  # Performance Insights — disabled for t4g (free tier is limited anyway)
  performance_insights_enabled = false

  # Prevent accidental deletion in prod
  deletion_protection = var.environment == "prod" ? true : false
  skip_final_snapshot = var.environment == "prod" ? false : true
  final_snapshot_identifier = var.environment == "prod" ? "${var.project_name}-${var.environment}-final-snapshot" : null

  # Auto minor version upgrades during maintenance window
  auto_minor_version_upgrade = true
  apply_immediately          = false

  tags = {
    Name = "${var.project_name}-${var.environment}-postgres"
  }
}
