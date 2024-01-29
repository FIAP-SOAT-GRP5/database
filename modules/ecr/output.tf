output "repository_url" {
  value = aws_ecr_repository.ecr_app.repository_url
}

output "cloudwatch_group" {
  value = aws_cloudwatch_log_group.app.name
}

output "cluster_id" {
  value = aws_ecs_cluster.cluster.id
}

output "cluster_name" {
  value = aws_ecs_cluster.cluster.name
}