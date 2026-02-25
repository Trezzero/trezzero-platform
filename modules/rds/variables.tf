variable "project_name" { type = string }
variable "environment" { type = string }
variable "private_db_subnet_ids" { type = list(string) }
variable "rds_security_group_id" { type = string }
variable "instance_class" { type = string default = "db.t4g.small" }
variable "allocated_storage" { type = number default = 20 }
variable "max_allocated_storage" { type = number default = 100 }
variable "db_name" { type = string }
variable "username" { type = string sensitive = true }
variable "password" { type = string sensitive = true }
variable "multi_az" { type = bool default = true }
