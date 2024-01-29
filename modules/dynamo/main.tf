resource "aws_dynamodb_table" "fiap_dynamodb" {
  name         = var.dynamo_table_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key
  attribute {
    name = var.hash_key
    type = "S" # Pode ser S para string ou N para numero
  }

  tags = var.tags

}