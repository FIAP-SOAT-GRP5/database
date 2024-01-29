variable "sqs_queue_name" {
  description = "(Optional) The name of the queue."
  type        = string
}

variable "delay_seconds" {
  description = "(Optional) The time in seconds that the delivery of all messages in the queue will be delayed."
  type        = number
}

variable "max_message_size" {
  description = " (Optional) The limit of how many bytes a message can contain before Amazon SQS rejects it."
  type        = number
}

variable "message_retention_seconds" {
  description = "(Optional) The number of seconds Amazon SQS retains a message. "
  type        = number
}

variable "tags" {
  description = "(Optional) A map of tags to assign to the queue."
}