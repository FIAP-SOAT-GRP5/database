terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = var.region
}

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
