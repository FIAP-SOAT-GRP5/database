variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "settings" {
  description = "Settings for the RDS"
  type        = map(any)
  default = {
    "tag_default" = {
      "name" = "fiap"
    }
    "database" = {
      "allocated_storage"   = 20
      "db_port"             = 3306
      "db_name_order"       = "fiap_db"
      "db_name_payment"     = "fiap_db"
      "engine"              = "mysql"
      "engine_version"      = "8.0.35"
      "instance_class"      = "db.t2.micro"
      "skip_final_snapshot" = true
      "publicly_accessible" = true
      "multi_az"            = false
      "identifier_order"    = "fiap-db-order"
      "identifier_payment"  = "fiap-db-payment"
    }
    "subnet" = {
      "count"                   = 2
      "map_public_ip_on_launch" = true
    }
    "lambda" = {
      "filename"      = "lambda.zip"
      "function_name" = "fiap-auth"
      "handler"       = "index.handler"
      "runtime"       = "nodejs18.x"
    }
  }
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
  ]
}

variable "db_username" {
  description = "Username for the database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}

variable "securiry_group_name_rds" {
  description = "Security Group name"
  type        = string
  default     = "FIAP-RDS"
}

variable "db_subnet_group_name_order" {
  description = "DB Group name"
  type        = string
  default     = "fiap_order"
}

variable "db_subnet_group_name_payment" {
  description = "DB Group name"
  type        = string
  default     = "fiap_payment"
}

variable "dynamo_table_name" {
  description = "Nome do tabela"
  type        = string
  default     = "FIAP"
}

variable "billing_mode" {
  description = "Billing mode"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "Chave da hash de criptografia do banco"
  type        = string
  default     = "ID"
}

variable "api_name" {
  description = "Nome da API"
  type        = string
  default     = "fiap"
}

variable "api_authorization" {
  description = "API Authorization"
  type        = string
  default     = "NONE"
}

variable "http_method" {
  description = "Metodo HTTP da API"
  type        = string
  default     = "ANY"
}

variable "integration_http_method" {
  description = "HTTP Method"
  type        = string
  default     = "POST"
}

variable "integration_type" {
  description = "Integration Type"
  type        = string
  default     = "AWS_PROXY"
}

variable "stage_deploy" {
  description = "Stage Deploy"
  type        = string
  default     = "prod"
}

variable "stage_name" {
  description = "Stage Name"
  type        = string
  default     = "fiap"
}

variable "create_order_name" {
  description = "Order Name"
  type        = string
  default     = "create_order"
}

variable "create_order_delay_seconds" {
  description = "Delay in seconds"
  type        = number
  default     = 1
}

variable "create_order_message_size" {
  description = "max message size"
  type        = number
  default     = 2048
}

variable "create_order_retention_seconds" {
  description = "Retention Seconds"
  type        = number
  default     = 86400
}


variable "update_order_name" {
  description = "Update Name"
  type        = string
  default     = "update_order"
}

variable "update_order_delay_seconds" {
  description = "Delay in seconds"
  type        = number
  default     = 1
}

variable "update_order_message_size" {
  description = "max message size"
  type        = number
  default     = 2048
}

variable "update_order_retention_seconds" {
  description = "Retention Seconds"
  type        = number
  default     = 86400
}

variable "cloudwatch_log_group_name_ecr" {
  description = "Log name"
  type        = string
  default     = "ecr"
}

variable "cloudwatch_log_group_name_app" {
  description = "Log name"
  type        = string
  default     = "app"
}

variable "respository_name" {
  description = "Repo name"
  type        = string
  default     = "app_repo"
}

variable "ecs_cluster_name" {
  description = "Cluster Name"
  type        = string
  default     = "app_cluster"
}

variable "ecs_role_name_production" {
  description = "ECS Role Name"
  type        = string
  default     = "ecs_role_production"
}

variable "ecs_role_name_payment" {
  description = "ECS Role Name"
  type        = string
  default     = "ecs_role_payment"
}

variable "ecs_role_name_order" {
  description = "ECS Role Name"
  type        = string
  default     = "ecs_role_order"
}

variable "policy_name_production" {
  description = "Policy Name"
  type        = string
  default     = "ecs_policy_name_production"
}

variable "policy_name_payment" {
  description = "Policy Name"
  type        = string
  default     = "ecs_policy_name_payment"
}

variable "policy_name_order" {
  description = "Policy Name"
  type        = string
  default     = "ecs_policy_name"
}

variable "excution_role_name_production" {
  description = "Execution Role Name"
  type        = string
  default     = "execution_role_production"
}

variable "excution_role_name_payment" {
  description = "Execution Role Name"
  type        = string
  default     = "execution_role_payment"
}

variable "excution_role_name_order" {
  description = "Execution Role Name"
  type        = string
  default     = "execution_role_order"
}

variable "execution_role_policy_production" {
  description = "Execution Role Policy"
  type        = string
  default     = "execution_role_policy_production"
}

variable "execution_role_policy_payment" {
  description = "Execution Role Policy"
  type        = string
  default     = "execution_role_policy_payment"
}

variable "execution_role_policy_order" {
  description = "Execution Role Policy"
  type        = string
  default     = "execution_role_policy_order"
}

variable "family_name" {
  description = "Family Name"
  type        = string
  default     = "app"
}

variable "container_name" {
  description = "Container Name"
  type        = string
  default     = "app"
}

variable "ecs_service_name_production" {
  description = "ECS Service Name"
  type        = string
  default     = "app-production"
}

variable "ecs_service_name_payment" {
  description = "ECS Service Name"
  type        = string
  default     = "app-payment"
}

variable "ecs_service_name_order" {
  description = "ECS Service Name"
  type        = string
  default     = "app-order"
}

variable "securiry_group_name_ecs_production" {
  description = "Security Group name"
  type        = string
  default     = "FIAP-ECS-PRODUCTION"
}

variable "securiry_group_name_ecs_payment" {
  description = "Security Group name"
  type        = string
  default     = "FIAP-ECS-PAYMENT"
}

variable "securiry_group_name_ecs_order" {
  description = "Security Group name"
  type        = string
  default     = "FIAP-ECS-ORDER"
}