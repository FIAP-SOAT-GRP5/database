resource "aws_api_gateway_rest_api" "fiap" {
  name = var.api_name

}

resource "aws_api_gateway_resource" "fiap_auth" {
  parent_id   = aws_api_gateway_rest_api.fiap.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.fiap.id
  path_part   = "auth"
}

resource "aws_api_gateway_method" "fiap_auth" {
  http_method   = var.http_method
  authorization = var.authorization
  resource_id   = aws_api_gateway_resource.fiap_auth.id
  rest_api_id   = aws_api_gateway_rest_api.fiap.id
  depends_on = [
    aws_api_gateway_resource.fiap_auth,
    aws_api_gateway_rest_api.fiap,
  ]
}
