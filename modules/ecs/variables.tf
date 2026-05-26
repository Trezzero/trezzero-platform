variable "project_name" {
  description = "Name of the whole project"
  type        = string
  default     = "trezzero"
}

variable "environment" {
  description = "App Environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC id of the app in the selected environment"
  type        = string
}

variable "aws_region" {
  description = "Region where our resources are deployed"
  type        = string
}

variable "private_app_subnet_ids" {
  description = "Private Subnets matching the VPC for the app"
  type        = list(string)
}

variable "ecs_task_execution_role_arn" {
  description = "Role for ECS to execute tasks"
  type        = string
}
variable "ecs_task_role_arn" {
  description = "ECS task role arn"
  type        = string
}

variable "backend_sg_id" {
  description = "App Security group ID"
  type        = string
}

variable "prometheus_sg_id" {
  description = "Prometheus Security Group id"
  type        = string
}
variable "grafana_sg_id" {
  description = "Grafana Security Group id"
  type        = string
}

variable "backend_target_group_arn" {
  description = "ARN of the ALB backend target group"
  type        = string
}

variable "grafana_target_group_arn" {
  description = "ARN of the ALB Grafana target group"
  type        = string
}

variable "backend_ecr_repository_name" {
  description = "App ECR repository name"
  type        = string
}
variable "backend_ecr_image_tag" {
  description = "Tag for the backend app"
  type        = string
  default     = "latest"
}

variable "backend_cpu" {
  description = "CPU request for the app container"
  type        = number
  default     = 512
}

variable "backend_memory" {
  description = "Memory request for the app container"
  type        = number
  default     = 1024
}

variable "backend_desired_count" {
  description = "Number of app containers desired"
  type        = number
  default     = 2
}
variable "backend_min_count" {
  description = "Minium number of app containers"
  type        = number
  default     = 1
}
variable "backend_max_count" {
  description = "Maximum number of app containers"
  type        = number
  default     = 6
}
variable "backend_port" {
  description = "App port number"
  type        = number
  default     = 3000
}

variable "prometheus_image" {
  description = "Prometheus docker image"
  type        = string
  default     = "prom/prometheus:latest" # change image tag to avoid issues with "latest"
}
variable "prometheus_cpu" {
  description = "CPU request for the promethues container"
  type        = number
  default     = 256
}
variable "prometheus_memory" {
  description = "Memory request for the promethues container"
  type        = number
  default     = 512
}

variable "efs_file_system_id" {
  description = "Storage system(EFS) for the ECS containers"
  type        = string
}
variable "efs_access_point_id" {
  description = "Access point for accessing file storage"
  type        = string
}

variable "grafana_image" {
  description = "Grafana docker image"
  type        = string
  default     = "grafana/grafana:latest" # change image tag to avoid issues with "latest"
}
variable "grafana_cpu" {
  description = "CPU request for the Grafana container"
  type        = number
  default     = 256
}
variable "grafana_memory" {
  description = "Memory request for the Grafana container"
  type        = number
  default     = 512
}
variable "grafana_admin_password" {
  description = "Grafana Password"
  type        = string
  sensitive   = true # store in secrets/parameter store
}

variable "db_host" {
  description = "Database host for the app"
  type        = string
}
variable "db_port" {
  description = "Database port number"
  type        = number
  default     = 5432
}
variable "db_name" {
  description = "Database name"
  type        = string
}
variable "db_secret_arn" {
  description = "Database secret arn for passwords"
  type        = string
}

variable "log_group_backend" {
  description = "App log group"
  type        = string
}
variable "log_group_prometheus" {
  description = "Prometheus log group"
  type        = string
}
variable "log_group_grafana" {
  description = "Grafana log group"
  type        = string
}
