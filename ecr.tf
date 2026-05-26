# Containter Repo
resource "aws_ecr_repository" "trez_platform" {
  name                 = var.repo_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}