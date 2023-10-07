output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.fiap_db.address
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.fiap_db.port
}

