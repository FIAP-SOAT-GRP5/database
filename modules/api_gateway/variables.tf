variable "api_name" {
  description = "Name of the REST API."
  type        = string
}

variable "http_method" {
  description = "HTTP Method (GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY)"
  type        = string
}

variable "authorization" {
  description = "Type of authorization used for the method (NONE, CUSTOM, AWS_IAM, COGNITO_USER_POOLS)"
  type        = string
}