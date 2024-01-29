variable "http_method" {
  description = "HTTP method (GET, POST, PUT, DELETE, HEAD, OPTION, ANY) when calling the associated resource."
  type        = string
}

variable "resource_id" {
  description = "(Required) API resource ID."
  type        = string
}

variable "rest_api_id" {
  description = "(Required) ID of the associated REST API."
  type        = string
}

variable "integration_http_method" {
  description = "(Optional) Integration HTTP method (GET, POST, PUT, DELETE, HEAD, OPTIONs, ANY, PATCH) specifying how API Gateway will interact with the back end."
  type        = string
}

variable "integration_type" {
  description = "(Required) Integration input's type. Valid values are HTTP (for HTTP backends), MOCK (not calling any real backend), AWS (for AWS services), AWS_PROXY (for Lambda proxy integration) and HTTP_PROXY (for HTTP proxy integration)."
  type        = string
}

variable "uri" {
  description = "(Optional) Input's URI. Required if type is AWS, AWS_PROXY, HTTP or HTTP_PROXY. "
  type        = string
}

variable "method_id" {
  description = "ID used in Method HTTP"
  type        = string
}

variable "stage_deploy" {
  description = "(Optional) Name of the stage to create with this deployment."
  type        = string
}

variable "stage_name" {
  description = "(Required) Name of the stage"
  type        = string
}

variable "tags" {
  description = "(Optional) Map of tags to assign to the resource."
}