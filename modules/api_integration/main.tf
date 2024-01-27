resource "aws_api_gateway_integration" "fiap_auth" {
  http_method             = var.http_method
  resource_id             = var.resource_id
  rest_api_id             = var.rest_api_id
  integration_http_method = var.integration_http_method
  type                    = var.integration_type
  uri                     = var.uri
}

resource "aws_api_gateway_deployment" "fiap" {
  rest_api_id = var.rest_api_id

  triggers = {
    redeployment = sha1(jsonencode([
      var.resource_id,
      var.method_id,
      aws_api_gateway_integration.fiap_auth.id,
    ]))
  }

  stage_name = var.stage_deploy

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "fiap" {
  deployment_id = aws_api_gateway_deployment.fiap.id
  rest_api_id   = var.rest_api_id
  stage_name    = var.stage_name

  tags = var.tags
}