variable "project_name" { type = string }
variable "environment" { type = string }
variable "aws_region" { type = string }
variable "vpc_id" { type = string }
variable "private_app_subnet_ids" { type = list(string) }

variable "ecs_task_execution_role_arn" { type = string }
variable "ecs_task_role_arn" { type = string }

variable "backend_sg_id" { type = string }
variable "prometheus_sg_id" { type = string }
variable "grafana_sg_id" { type = string }

variable "backend_target_group_arn" { type = string }
variable "grafana_target_group_arn" { type = string }

variable "backend_ecr_repository_name" { type = string }
variable "backend_ecr_image_tag" { type = string default = "latest" }
variable "backend_cpu" { type = number default = 512 }
variable "backend_memory" { type = number default = 1024 }
variable "backend_desired_count" { type = number default = 2 }
variable "backend_min_count" { type = number default = 1 }
variable "backend_max_count" { type = number default = 6 }
variable "backend_port" { type = number default = 3000 }

variable "prometheus_image" { type = string default = "prom/prometheus:latest" }
variable "prometheus_cpu" { type = number default = 256 }
variable "prometheus_memory" { type = number default = 512 }
variable "efs_file_system_id" { type = string }
variable "efs_access_point_id" { type = string }

variable "grafana_image" { type = string default = "grafana/grafana:latest" }
variable "grafana_cpu" { type = number default = 256 }
variable "grafana_memory" { type = number default = 512 }
variable "grafana_admin_password" { type = string sensitive = true }

variable "db_host" { type = string }
variable "db_port" { type = number default = 5432 }
variable "db_name" { type = string }
variable "db_secret_arn" { type = string }

variable "log_group_backend" { type = string }
variable "log_group_prometheus" { type = string }
variable "log_group_grafana" { type = string }
