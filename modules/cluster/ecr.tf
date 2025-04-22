### ECR 레포 생성
# resource "aws_ecr_repository" "ecr_repo" {
#   name = "test-repo-1"
#   image_tag_mutability = "MUTABLE"
  
#   image_scanning_configuration {
#     scan_on_push = false
#   }
#   tags = var.ecr_tags
# }

### ECR 레포 가져오기
data "aws_ecr_repository" "ecr_repo" {
  name = "test-repo"
}


resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  repository = data.aws_ecr_repository.ecr_repo.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 5 images",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["v"],
        "countType": "imageCountMoreThan",
        "countNumber": 5
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}