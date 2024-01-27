variable "cloudwatch_log_group_name" {
  description = "Log group name"
  type        = string
}

variable "respository_name" {
  description = "Repository Name"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "tags" {
  description = "Resource tags"
}
