output "rds_hostname" {
  value = aws_db_instance.fiap_db.address
}

output "rds_port" {
  value = aws_db_instance.fiap_db.port
}