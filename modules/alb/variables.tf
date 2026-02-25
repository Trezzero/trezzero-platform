variable "project_name" { type = string }
variable "environment" { type = string }
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "alb_security_group_id" { type = string }
variable "certificate_arn" { type = string }
variable "backend_port" { type = number default = 3000 }
variable "grafana_port" { type = number default = 3000 }
variable "grafana_host" { type = string default = "" }
