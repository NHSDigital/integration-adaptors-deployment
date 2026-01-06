resource "aws_ecr_repository" "ecr_repository" {
  count = length(var.ecr_repositories)
  name = var.ecr_repositories[count.index].name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = var.ecr_repositories[count.index].scan
  }

  tags = merge(local.default_tags, {
    Name = "${local.resource_prefix}-${var.ecr_repositories[count.index].name}_ecr"
  })
}

resource "aws_ecr_lifecycle_policy" "cleanup_old_images" {
  repository = aws_ecr_repository.ecr_repository.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire images older than 14 days"
        selection = {
          tagStatus   = "any"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 14
        }
        action = {
          type = "expire"
        }
      }
    ]
  })

}