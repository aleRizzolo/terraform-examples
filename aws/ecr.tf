resource "aws_ecr_repository" "ecr_repository" {
  name                 = var.ecr_name
  force_delete         = false
  image_tag_mutability = var.image_tag_mutability
  encryption_configuration {
    encryption_type = var.encryption_type
  }
}