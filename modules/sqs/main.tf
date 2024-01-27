resource "aws_sqs_queue" "fiap_queue" {
  name                      = var.sqs_queue_name
  delay_seconds             = var.delay_seconds
  max_message_size          = var.max_message_size
  message_retention_seconds = var.message_retention_seconds

  tags = var.tags
}

resource "aws_sqs_queue_policy" "fiap_queue_policy" {
  queue_url = aws_sqs_queue.fiap_queue.id
  policy    = data.aws_iam_policy_document.fiap_document.json
}