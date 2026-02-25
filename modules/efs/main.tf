# ─────────────────────────────────────────────
# EFS File System for Prometheus storage
# gp2 is the default; no provisioned throughput needed
# for Prometheus at this scale
# ─────────────────────────────────────────────
resource "aws_efs_file_system" "prometheus" {
  creation_token   = "${var.project_name}-${var.environment}-prometheus"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = true

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-efs-prometheus"
  }
}

# Mount targets — one per private app subnet
resource "aws_efs_mount_target" "prometheus" {
  count           = length(var.private_app_subnet_ids)
  file_system_id  = aws_efs_file_system.prometheus.id
  subnet_id       = var.private_app_subnet_ids[count.index]
  security_groups = [var.efs_security_group_id]
}

# Access point scoped to /prometheus directory
resource "aws_efs_access_point" "prometheus" {
  file_system_id = aws_efs_file_system.prometheus.id

  posix_user {
    gid = 65534 # nobody
    uid = 65534
  }

  root_directory {
    path = "/prometheus"
    creation_info {
      owner_gid   = 65534
      owner_uid   = 65534
      permissions = "755"
    }
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-efs-ap-prometheus"
  }
}

# EFS backup policy
resource "aws_efs_backup_policy" "prometheus" {
  file_system_id = aws_efs_file_system.prometheus.id

  backup_policy {
    status = "ENABLED"
  }
}
