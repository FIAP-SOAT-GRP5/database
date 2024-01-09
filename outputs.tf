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

output "sqs_create_order_url" {
  description = "SQS Create Order URL"
  value       = aws_sqs_queue.fiap_create_order.id
}

output "sqs_update_order_status_url" {
  description = "SQS Update Order Status URL"
  value       = aws_sqs_queue.fiap_update_order_status.id
}
