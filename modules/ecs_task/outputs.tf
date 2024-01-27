output "security_groups_id" {
  value = aws_security_group.ecs_service.id
}

output "service_name" {
  value = aws_ecs_service.app.name
}