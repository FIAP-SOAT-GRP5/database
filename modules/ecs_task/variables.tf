variable "ecs_role_name" {
  description = "Role Name"
  type = string
}

variable "policy_name" {
  description = "Policy Name"
  type = string
}

variable "excution_role_name" {
  description = "Execution Role Name"
  type = string
}

variable "execution_role_policy" {
  description = "Execution Policy"
  type = string
}

variable "tags" {
  description = "Resource tags"
}

variable "family_name" {
  description = "Family Name"
  type = string
}

variable "container_name" {
  description = "Container Name"
  type = string
}

variable "image_url" {
  description = "Image URL"
  type = string
}

variable "cloudwatch_log_group_name" {
  description = "Log group name"
  type = string
}

variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "security_group_name" {
  description = "Security Group"
  type = string
}

variable "ecs_service_name" {
  description = "ECS Service Name"
  type = string
}

variable "cluster_id" {
  description = "Cluster ID"
  type = string
}

variable "security_groups_ids" {
  description = "security groups ids"
  type = list(string)
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type = list(string)
}

