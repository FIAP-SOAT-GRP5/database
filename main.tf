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
    Name = var.settings.tag_default.name
  }
}

resource "aws_internet_gateway" "fiap" {
  vpc_id = aws_vpc.fiap.id

  tags = {
    Name = var.settings.tag_default.name
  }
}

resource "aws_subnet" "fiap" {
  count                   = var.settings.subnet.count
  vpc_id                  = aws_vpc.fiap.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.settings.subnet.map_public_ip_on_launch
  tags = {
    Name = var.settings.tag_default.name
  }
}

resource "aws_route_table" "fiap" {
  vpc_id = aws_vpc.fiap.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.fiap.id
  }

  tags = {
    Name = var.settings.tag_default.name
  }
}

resource "aws_route_table_association" "fiap" {
  count          = var.settings.subnet.count
  subnet_id      = aws_subnet.fiap[count.index].id
  route_table_id = aws_route_table.fiap.id
}


###################
# RDS
###################
resource "aws_security_group" "fiap_rds" {
  name   = "FIAP-RDS"
  vpc_id = aws_vpc.fiap.id

  ingress {
    description = "MySQL traffic"
    from_port   = var.settings.database.db_port
    to_port     = var.settings.database.db_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.settings.tag_default.name
  }
}

resource "aws_db_subnet_group" "fiap" {
  name       = "fiap"
  subnet_ids = [for subnet in aws_subnet.fiap : subnet.id]

  tags = {
    Name = var.settings.tag_default.name
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
  port                   = var.settings.database.db_port

  tags = {
    Name = var.settings.tag_default.name
  }
}

###################
# Lambda
###################
resource "aws_iam_role" "fiap" {
  name               = "serverless_example_lambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "fiap" {
  filename         = var.settings.lambda.filename
  function_name    = var.settings.lambda.function_name
  handler          = var.settings.lambda.handler
  runtime          = var.settings.lambda.runtime
  role             = aws_iam_role.fiap.arn
  source_code_hash = filebase64sha256(var.settings.lambda.filename)
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fiap.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.fiap.execution_arn}/*/*"
}

###################
# API Gateway
###################
resource "aws_api_gateway_rest_api" "fiap" {
  name = "fiap"

}

resource "aws_api_gateway_resource" "fiap_auth" {
  parent_id   = aws_api_gateway_rest_api.fiap.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.fiap.id
  path_part   = "auth"
}

resource "aws_api_gateway_method" "fiap_auth" {
  http_method   = "ANY"
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
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.fiap.invoke_arn
  depends_on = [
    aws_api_gateway_method.fiap_auth,
    aws_api_gateway_resource.fiap_auth,
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
    ]))
  }

  stage_name = "prod"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "fiap" {
  deployment_id = aws_api_gateway_deployment.fiap.id
  rest_api_id   = aws_api_gateway_rest_api.fiap.id
  stage_name    = "fiap"
}
