variable "project_name" { type = string }
variable "environment" { type = string }
variable "aws_region" { type = string default = "af-south-1" }
variable "vpc_cidr" { type = string }
variable "availability_zones" { type = list(string) }
variable "public_subnet_cidrs" { type = list(string) }
variable "private_app_subnet_cidrs" { type = list(string) }
variable "private_db_subnet_cidrs" { type = list(string) }
variable "vpc_endpoint_sg_id" { type = string default = "" }
