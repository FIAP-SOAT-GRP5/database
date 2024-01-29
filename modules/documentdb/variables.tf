variable "subnet_group_name" {
  description = "Name for the DocumentDB subnet group"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DocumentDB cluster"
  type        = list(string)
}

variable "cluster_identifier" {
  description = "Identifier for the DocumentDB cluster"
  type        = string
}

variable "master_username" {
  description = "Username for the DocumentDB master user"
  type        = string
}

variable "master_password" {
  description = "Password for the DocumentDB master user"
  type        = string
}

variable "backup_retention_period" {
  description = "Backup retention period for the DocumentDB cluster"
  type        = number
}

variable "skip_final_snapshot" {
  description = "Skip the final snapshot when deleting the DocumentDB cluster"
  type        = bool
}

variable "apply_immediately" {
  description = "Apply changes immediately or not"
  type        = bool
}

variable "engine" {
  description = "Database engine to be used for the DocumentDB cluster"
  type        = string
}

variable "engine_version" {
  description = "Version of the database engine to be used for the DocumentDB cluster"
  type        = string
}

variable "storage_encrypted" {
  description = "Specify whether the DocumentDB cluster is encrypted"
  type        = bool
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs for the DocumentDB cluster"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name for the DocumentDB cluster"
  type        = string
}

variable "environment" {
  description = "Environment for the DocumentDB cluster"
  type        = string
}

variable "tags" {
  description = "A map of tags to populate on the created table."
}

variable "db_subnet_group_name"{
    description = "db_subnet_group_name"
    
}

variable "instance_class" {
  description = "Instance class for the DocumentDB cluster"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones for the DocumentDB cluster"
  type        = list(string)
}