output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.fiap_db.address
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.fiap_db.port
}

output "apigateway_url" {
  description = "API Gateway URL"
  value       = aws_api_gateway_deployment.fiap.invoke_url
}
