terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_db_instance" "fiap_db" {
  allocated_storage   = 20
  db_name             = "fiap_db"
  engine              = "mysql"
  engine_version      = "8.0.33"
  instance_class      = "db.t2.micro"
  username            = "admin"
  password            = "fiap1234"
  skip_final_snapshot = true
  multi_az            = false
  identifier          = "fiap-db"
}
