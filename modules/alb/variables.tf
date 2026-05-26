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

variable "public_subnet_ids" {
  description = "Public Subnets matching the VPC"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "App security group"
  type        = string
}

variable "certificate_arn" {
  description = "Certificate for the HTTPS listener"
  type        = string
}

variable "backend_port" {
  description = "Target group App port"
  type        = number
  default     = 3000
}

variable "grafana_port" {
  description = "Target group Grafana port"
  type        = number
  default     = 3000
}

variable "grafana_host" {
  description = "DNS name for grafana host listener"
  type        = string
  default     = ""
}