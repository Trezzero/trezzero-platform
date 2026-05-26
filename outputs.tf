# ─────────────────────────────────────────────
# ECR
# ─────────────────────────────────────────────

output "repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.my_repository.repository_url
}

output "repository_arn" {
  description = "ARN of the ECR repository"
  value       = aws_ecr_repository.my_repository.arn
}

output "repository_name" {
  description = "Name of the ECR repository"
  value       = aws_ecr_repository.my_repository.name
}