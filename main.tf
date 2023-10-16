terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
###################
# Initialize the
# AWS provider
###################
provider "aws" {
  alias  = "us_east_1"
  region = var.region
}
###################
# VPC and Network
###################
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "fiap" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "FIAP"
  }
}

resource "aws_internet_gateway" "fiap" {
  vpc_id = aws_vpc.fiap.id

  tags = {
    Name = "FIAP"
  }
}

resource "aws_subnet" "fiap_public" {
  count                   = var.subnet_count.public
  vpc_id                  = aws_vpc.fiap.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "FIAP-Public-${count.index}"
  }
}

resource "aws_subnet" "fiap_private" {
  count                   = var.subnet_count.private
  vpc_id                  = aws_vpc.fiap.id
  cidr_block              = var.private_subnet_cidr_blocks[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "FIAP-Private-${count.index}"
  }
}

resource "aws_route_table" "fiap_public" {
  vpc_id = aws_vpc.fiap.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.fiap.id
  }

  tags = {
    Name = "FIAP"
  }
}

resource "aws_route_table_association" "fiap_public" {
  count          = var.subnet_count.public
  subnet_id      = aws_subnet.fiap_public[count.index].id
  route_table_id = aws_route_table.fiap_public.id
}

resource "aws_route_table" "fiap_private" {
  vpc_id = aws_vpc.fiap.id

  tags = {
    Name = "FIAP"
  }
}

resource "aws_route_table_association" "fiap_private" {
  count          = var.subnet_count.private
  subnet_id      = aws_subnet.fiap_private[count.index].id
  route_table_id = aws_route_table.fiap_private.id
}


###################
# RDS
###################

resource "aws_security_group" "fiap_rds" {
  name   = "FIAP-RDS"
  vpc_id = aws_vpc.fiap.id

  ingress {
    description = "MySQL traffic"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "FIAP"
  }
}

resource "aws_db_subnet_group" "fiap" {
  name       = "fiap"
  subnet_ids = [for subnet in aws_subnet.fiap_private : subnet.id]

  tags = {
    Name = "FIAP"
  }
}

resource "aws_db_instance" "fiap_db" {
  allocated_storage      = var.settings.database.allocated_storage
  db_name                = var.settings.database.db_name
  engine                 = var.settings.database.engine
  engine_version         = var.settings.database.engine_version
  instance_class         = var.settings.database.instance_class
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = var.settings.database.skip_final_snapshot
  publicly_accessible    = var.settings.database.publicly_accessible
  multi_az               = var.settings.database.multi_az
  identifier             = var.settings.database.identifier
  db_subnet_group_name   = aws_db_subnet_group.fiap.name
  vpc_security_group_ids = [aws_security_group.fiap_rds.id]
  port                   = 3306

  tags = {
    Name = "FIAP"
  }
}

###################
# ECR
###################
resource "aws_ecr_repository" "fiap" {
  provider = aws.us_east_1

  name                 = var.settings.ecr.repository_name
  force_delete         = var.settings.ecr.force_delete
  image_tag_mutability = var.settings.ecr.image_tag_mutability
  image_scanning_configuration {
    scan_on_push = var.settings.ecr.scan_on_push
  }

  tags = {
    Name = "FIAP"
  }
}

###################
# Lambda
###################
# resource "aws_lambda_permission" "apigw_lambda" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.lambda.function_name
#   principal     = "apigateway.amazonaws.com"

#   # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
#   source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
# }

# resource "aws_lambda_function" "lambda" {
#   filename      = "lambda.zip"
#   function_name = "mylambda"
#   role          = aws_iam_role.role.arn
#   handler       = "lambda.lambda_handler"
#   runtime       = "python3.7"

#   source_code_hash = filebase64sha256("lambda.zip")
# }

###################
# VPC Link
###################
resource "aws_api_gateway_vpc_link" "fiap_app" {
  name        = "fiap_app"
  target_arns = [var.load_balancer_arn]
}

###################
# API Gateway
###################
resource "aws_api_gateway_rest_api" "fiap" {
  name = "fiap"

}

resource "aws_api_gateway_resource" "fiap_auth" {
  parent_id   = aws_api_gateway_rest_api.fiap.root_resource_id
  path_part   = "auth"
  rest_api_id = aws_api_gateway_rest_api.fiap.id
}

resource "aws_api_gateway_method" "fiap_auth" {
  http_method   = "POST"
  authorization = "NONE"
  resource_id   = aws_api_gateway_resource.fiap_auth.id
  rest_api_id   = aws_api_gateway_rest_api.fiap.id
  depends_on = [
    aws_api_gateway_resource.fiap_auth,
    aws_api_gateway_rest_api.fiap,
  ]
}

resource "aws_api_gateway_integration" "fiap_auth" {
  http_method             = aws_api_gateway_method.fiap_auth.http_method
  resource_id             = aws_api_gateway_resource.fiap_auth.id
  rest_api_id             = aws_api_gateway_rest_api.fiap.id
  integration_http_method = "POST"
  type                    = "MOCK"
  # TODO: Implementar lambda
  # type        = "AWS_PROXY"
  # uri         = aws_lambda_function.lambda.invoke_arn
  depends_on = [
    aws_api_gateway_method.fiap_auth,
    aws_api_gateway_resource.fiap_auth,
    aws_api_gateway_rest_api.fiap,
  ]
}

resource "aws_api_gateway_resource" "fiap_app" {
  parent_id   = aws_api_gateway_rest_api.fiap.root_resource_id
  path_part   = "{proxy+}"
  rest_api_id = aws_api_gateway_rest_api.fiap.id
}

resource "aws_api_gateway_method" "fiap_app" {
  http_method   = "ANY"
  authorization = "NONE"
  resource_id   = aws_api_gateway_resource.fiap_app.id
  rest_api_id   = aws_api_gateway_rest_api.fiap.id
  request_parameters = {
    "method.request.path.proxy"           = true
    "method.request.header.Authorization" = true
  }
  depends_on = [
    aws_api_gateway_resource.fiap_app,
    aws_api_gateway_rest_api.fiap,
  ]
}

resource "aws_api_gateway_integration" "fiap_app" {
  http_method             = aws_api_gateway_method.fiap_app.http_method
  resource_id             = aws_api_gateway_resource.fiap_app.id
  rest_api_id             = aws_api_gateway_rest_api.fiap.id
  integration_http_method = "ANY"
  # Valid values are:
  # - HTTP (for HTTP backends)
  # - MOCK (not calling any real backend)
  # - AWS (for AWS services)
  # - AWS_PROXY (for Lambda proxy integration)
  # - HTTP_PROXY (for HTTP proxy integration).
  # An HTTP or HTTP_PROXY integration with a connection_type of VPC_LINK is referred to
  # as a private integration and uses a VpcLink to connect API Gateway to a network load balancer of a VPC.
  type                 = "HTTP_PROXY"
  uri                  = "http://${var.load_balancer_dns}/{proxy}"
  passthrough_behavior = "WHEN_NO_MATCH"
  content_handling     = "CONVERT_TO_TEXT"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.fiap_app.id

  request_parameters = {
    "integration.request.path.proxy"           = "method.request.path.proxy"
    "integration.request.header.Accept"        = "'application/json'"
    "integration.request.header.Authorization" = "method.request.header.Authorization"
  }

  depends_on = [
    aws_api_gateway_vpc_link.fiap_app,
    aws_api_gateway_method.fiap_app,
    aws_api_gateway_resource.fiap_app,
    aws_api_gateway_rest_api.fiap,
  ]
}

resource "aws_api_gateway_deployment" "fiap" {
  rest_api_id = aws_api_gateway_rest_api.fiap.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.fiap_auth.id,
      aws_api_gateway_method.fiap_auth.id,
      aws_api_gateway_integration.fiap_auth.id,
      aws_api_gateway_resource.fiap_app.id,
      aws_api_gateway_method.fiap_app.id,
      aws_api_gateway_integration.fiap_app.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "fiap" {
  deployment_id = aws_api_gateway_deployment.fiap.id
  rest_api_id   = aws_api_gateway_rest_api.fiap.id
  stage_name    = "fiap"
}
