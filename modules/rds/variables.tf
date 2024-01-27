variable "db_subnet_group_name" {
  description = "The name of the DB subnet group. If omitted, Terraform will assign a random, unique name."
  type        = string
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs."
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to assign to the resource."
}

variable "allocated_storage" {
  description = "The allocated storage in gibibytes"
  type        = string
}

variable "db_name" {
  description = "The name of the database to create when the DB instance is created."
  type        = string
}

variable "engine" {
  description = "The database engine to use."
  type        = string
}

variable "engine_version" {
  description = "The engine version to use."
  type        = string
}

variable "instance_class" {
  description = "The instance type of the RDS instance."
  type        = string
}

variable "db_username" {
  description = "Username for the master DB user. Cannot be specified for a replica."
  type        = string
}

variable "db_password" {
  description = "Password for the master DB user. "
  type        = string
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted."
  type        = string
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible."
  type        = string
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = string
}

variable "identifier" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier. "
  type        = string
}

variable "security_group_ids" {
  description = "List of VPC security groups to associate."
  type        = list(string)
}

variable "db_port" {
  description = "The port on which the DB accepts connections."
  type        = string
}