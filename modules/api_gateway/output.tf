output "rest_api_id" {
  value = aws_api_gateway_rest_api.fiap.id
}

output "http_method" {
  value = aws_api_gateway_method.fiap_auth.http_method
}

output "resource_id" {
  value = aws_api_gateway_resource.fiap_auth.id
}

output "api_arn" {
  value = aws_api_gateway_rest_api.fiap.execution_arn
}

output "http_id" {
  value = aws_api_gateway_method.fiap_auth.id
}