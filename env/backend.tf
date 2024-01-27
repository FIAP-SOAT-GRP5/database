terraform {
  backend "s3" {
    bucket = "bucket-name-unique" # Substituir por nome real do bucket
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}