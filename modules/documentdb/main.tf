resource "aws_docdb_subnet_group" "docdb_subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids

  
}

resource "aws_docdb_cluster_parameter_group" "docdb_cluster_parameter_group" {
  name        = "docdb-cluster-parameter-group"
  family      = "docdb5.0"
  description = "docdb-cluster-parameter-group"

  parameter {
    name  = "tls"
    value = "disabled"
  }
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = 1
  cluster_identifier = aws_docdb_cluster.docdb.id
  instance_class     = var.instance_class
}

resource "aws_docdb_cluster" "docdb" {
  cluster_identifier      = var.cluster_identifier
  master_username         = var.master_username
  master_password         = var.master_password
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  db_subnet_group_name    = aws_docdb_subnet_group.docdb_subnet_group.name
  apply_immediately = var.apply_immediately
  availability_zones = var.availability_zones
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.docdb_cluster_parameter_group.name
  engine               = var.engine
  engine_version       = var.engine_version
  storage_encrypted     = var.storage_encrypted
  vpc_security_group_ids = var.vpc_security_group_ids

  tags = var.tags
}

