output "security_group_ids" {
  value = aws_security_group.fiap_rds.id
}

output "subnet_ids" {
  value = [for subnet in aws_subnet.fiap : subnet.id]
}

output "vpc_id" {
  value = aws_vpc.fiap.id
}

output "securiry_group_name" {
  value = aws_security_group.fiap_rds.name
}