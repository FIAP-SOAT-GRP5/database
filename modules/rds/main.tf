
resource "aws_db_subnet_group" "fiap" {
  name       = var.db_subnet_group_name
  subnet_ids = var.subnet_ids

  tags = var.tags
}

resource "aws_db_instance" "fiap_db" {
  allocated_storage      = var.allocated_storage
  db_name                = var.db_name
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = var.skip_final_snapshot
  publicly_accessible    = var.publicly_accessible
  multi_az               = var.multi_az
  identifier             = var.identifier
  db_subnet_group_name   = aws_db_subnet_group.fiap.name
  vpc_security_group_ids = var.security_group_ids
  port                   = var.db_port

  tags = var.tags
}