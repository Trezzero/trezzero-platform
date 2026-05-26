variable "project_name" {
  description = "Name of the whole project"
  type        = string
  default     = "trezzero"
}

variable "environment" {
  description = "App Environment"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days logs are retained for before being deleted"
  type    = number
  default = 5
}