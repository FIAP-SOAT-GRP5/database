variable "filename" {
  description = "Path to the function's deployment package within the local filesystem. "
  type        = string
}

variable "function_name" {
  description = "Unique name for your Lambda Function."
  type        = string
}

variable "handler" {
  description = "Function entrypoint in your code."
  type        = string
}

variable "runtime" {
  description = "Identifier of the function's runtime."
  type        = string
}

variable "source_arn" {
  description = "When the principal is an AWS service, the ARN of the specific resource within that service to grant permission to"
  type        = string
}
