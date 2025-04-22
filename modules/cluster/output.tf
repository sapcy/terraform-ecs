# output "dns_name" {
#   description = "ALB DNS Name"
#   value = aws_lb.ALB.dns_name
# }
output "ecr_name" {
  description = "ECR NAME"
  value = data.aws_ecr_repository.ecr_repo.name
}
output "ecr_url" {
  description = "ECR NAME"
  value = data.aws_ecr_repository.ecr_repo.repository_url
}
output "ecs-cluster-name" {
  description = "ECS CLUSTER NAME"
  value = aws_ecs_cluster.ecs_cluster.name
}
output "ecs-service-name" {
  description = "ECS SERVICE NAME"
  value = aws_ecs_service.ecs_service.name
}