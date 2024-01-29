resource "aws_vpc" "fiap" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags                 = var.tags
}

resource "aws_internet_gateway" "fiap" {
  vpc_id = aws_vpc.fiap.id
  tags   = var.tags

}

resource "aws_subnet" "fiap" {
  count                   = var.subnet_count
  vpc_id                  = aws_vpc.fiap.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags                    = var.tags

}

resource "aws_route_table" "fiap" {
  vpc_id = aws_vpc.fiap.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.fiap.id
  }

  tags = var.tags
}

resource "aws_route_table_association" "fiap" {
  count          = var.subnet_count
  subnet_id      = aws_subnet.fiap[count.index].id
  route_table_id = aws_route_table.fiap.id
}

resource "aws_security_group" "fiap_rds" {
  name   = var.securiry_group_name
  vpc_id = aws_vpc.fiap.id

  ingress {
    description = "Ports"
    from_port   = "0"
    to_port     = "0"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}