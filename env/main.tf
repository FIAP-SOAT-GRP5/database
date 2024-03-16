module "aws_network" {
  source                    = "../modules/network"
  subnet_count              = var.settings.subnet.count
  vpc_cidr_block            = var.vpc_cidr_block
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  map_public_ip_on_launch   = var.settings.subnet.map_public_ip_on_launch
  tags                      = var.settings.tag_default
  securiry_group_name       = var.securiry_group_name_rds
  from_db_port              = var.settings.database.db_port
  to_db_port                = var.settings.database.db_port
}

module "aws_rds_order" {
  source               = "../modules/rds"
  db_subnet_group_name = var.db_subnet_group_name_order
  subnet_ids           = module.aws_network.subnet_ids
  allocated_storage    = var.settings.database.allocated_storage
  db_name              = var.settings.database.db_name_order
  engine               = var.settings.database.engine
  engine_version       = var.settings.database.engine_version
  instance_class       = var.settings.database.instance_class
  db_username          = var.db_username
  db_password          = var.db_password
  skip_final_snapshot  = var.settings.database.skip_final_snapshot
  publicly_accessible  = var.settings.database.publicly_accessible
  multi_az             = var.settings.database.multi_az
  identifier           = var.settings.database.identifier_order
  security_group_ids   = [module.aws_network.security_group_ids]
  db_port              = var.settings.database.db_port
  tags                 = var.settings.tag_default
}

module "aws_rds_production" {
  source               = "../modules/rds"
  db_subnet_group_name = var.db_subnet_group_name_production
  subnet_ids           = module.aws_network.subnet_ids
  allocated_storage    = var.settings.database.allocated_storage
  db_name              = var.settings.database.db_name_production
  engine               = var.settings.database.engine
  engine_version       = var.settings.database.engine_version
  instance_class       = var.settings.database.instance_class
  db_username          = var.db_username
  db_password          = var.db_password
  skip_final_snapshot  = var.settings.database.skip_final_snapshot
  publicly_accessible  = var.settings.database.publicly_accessible
  multi_az             = var.settings.database.multi_az
  identifier           = var.settings.database.identifier_production
  security_group_ids   = [module.aws_network.security_group_ids]
  db_port              = var.settings.database.db_port
  tags                 = var.settings.tag_default
}

module "api_gateway" {
  source        = "../modules/api_gateway"
  api_name      = var.api_name
  authorization = var.api_authorization
  http_method   = var.http_method
}
# lambdas para cada microservico
module "lambda" {
  source        = "../modules/lambda"
  filename      = var.settings.lambda.filename
  function_name = var.settings.lambda.function_name
  handler       = var.settings.lambda.handler
  runtime       = var.settings.lambda.runtime
  source_arn    = module.api_gateway.api_arn
}
# integracao das lambdas
module "api_integration" {
  source                  = "../modules/api_integration"
  http_method             = module.api_gateway.http_method
  resource_id             = module.api_gateway.resource_id
  rest_api_id             = module.api_gateway.rest_api_id
  integration_http_method = var.integration_http_method
  integration_type        = var.integration_type
  uri                     = module.lambda.invoke_arn
  method_id               = module.api_gateway.http_id
  stage_deploy            = var.stage_deploy
  stage_name              = var.stage_name
  tags                    = var.settings.tag_default
}
# SQS queue para cada microservico
module "sqs_queue_create_order_payment" {
  source                    = "../modules/sqs"
  sqs_queue_name            = var.create_order_name_payment
  delay_seconds             = var.create_order_delay_seconds
  max_message_size          = var.create_order_message_size
  message_retention_seconds = var.create_order_retention_seconds
  tags                      = var.settings.tag_default
}

module "sqs_queue_create_order_production" {
  source                    = "../modules/sqs"
  sqs_queue_name            = var.create_order_name_production
  delay_seconds             = var.create_order_delay_seconds
  max_message_size          = var.create_order_message_size
  message_retention_seconds = var.create_order_retention_seconds
  tags                      = var.settings.tag_default
}

module "sqs_queue_payment_canceled_order" {
  source                    = "../modules/sqs"
  sqs_queue_name            = var.payment_canceled_name_order
  delay_seconds             = var.payment_canceled_delay_seconds
  max_message_size          = var.payment_canceled_message_size
  message_retention_seconds = var.payment_canceled_retention_seconds
  tags                      = var.settings.tag_default
}

module "sqs_queue_payment_canceled_production" {
  source                    = "../modules/sqs"
  sqs_queue_name            = var.payment_canceled_name_production
  delay_seconds             = var.payment_canceled_delay_seconds
  max_message_size          = var.payment_canceled_message_size
  message_retention_seconds = var.payment_canceled_retention_seconds
  tags                      = var.settings.tag_default
}

module "sqs_queue_payment_approved_order" {
  source                    = "../modules/sqs"
  sqs_queue_name            = var.payment_approved_name_order
  delay_seconds             = var.payment_approved_delay_seconds
  max_message_size          = var.payment_approved_message_size
  message_retention_seconds = var.payment_approved_retention_seconds
  tags                      = var.settings.tag_default
}

module "sqs_queue_payment_approved_production" {
  source                    = "../modules/sqs"
  sqs_queue_name            = var.payment_approved_name_production
  delay_seconds             = var.payment_approved_delay_seconds
  max_message_size          = var.payment_approved_message_size
  message_retention_seconds = var.payment_approved_retention_seconds
  tags                      = var.settings.tag_default
}

module "sqs_queue_update_order" {
  source                    = "../modules/sqs"
  sqs_queue_name            = var.update_order_name
  delay_seconds             = var.update_order_delay_seconds
  max_message_size          = var.update_order_message_size
  message_retention_seconds = var.update_order_retention_seconds
  tags                      = var.settings.tag_default
}

module "ecr_repo_production" {
  source                    = "../modules/ecr"
  cloudwatch_log_group_name = var.cloudwatch_log_group_name_ecr_production
  respository_name          = var.respository_name_production
  ecs_cluster_name          = var.ecs_cluster_name_production
  tags                      = var.settings.tag_default
}

module "ecr_repo_payment" {
  source                    = "../modules/ecr"
  cloudwatch_log_group_name = var.cloudwatch_log_group_name_ecr_payment
  respository_name          = var.respository_name_payment
  ecs_cluster_name          = var.ecs_cluster_name_payment
  tags                      = var.settings.tag_default
}

module "ecr_repo_order" {
  source                    = "../modules/ecr"
  cloudwatch_log_group_name = var.cloudwatch_log_group_name_ecr_order
  respository_name          = var.respository_name_order
  ecs_cluster_name          = var.ecs_cluster_name_order
  tags                      = var.settings.tag_default
}

module "ecs_task_definition_production" {
  source                    = "../modules/ecs_task"
  ecs_role_name             = var.ecs_role_name_production
  policy_name               = var.policy_name_production
  excution_role_name        = var.excution_role_name_production
  execution_role_policy     = var.execution_role_policy_production
  family_name               = var.family_name_production
  container_name            = var.container_name_production
  image_url                 = module.ecr_repo_production.repository_url
  cloudwatch_log_group_name = var.cloudwatch_log_group_name_ecr_production
  vpc_id                    = module.aws_network.vpc_id
  security_group_name       = var.securiry_group_name_ecs_production
  ecs_service_name          = var.ecs_service_name_production
  cluster_id                = module.ecr_repo_production.cluster_id
  security_groups_ids       = [module.aws_network.security_group_ids]
  subnet_ids                = module.aws_network.subnet_ids
  tags                      = var.settings.tag_default
}

module "ecs_task_definition_payment" {
  source                    = "../modules/ecs_task"
  ecs_role_name             = var.ecs_role_name_payment
  policy_name               = var.policy_name_payment
  excution_role_name        = var.excution_role_name_payment
  execution_role_policy     = var.execution_role_policy_payment
  family_name               = var.family_name_payment
  container_name            = var.container_name_payment
  image_url                 = module.ecr_repo_payment.repository_url
  cloudwatch_log_group_name = var.cloudwatch_log_group_name_ecr_payment
  vpc_id                    = module.aws_network.vpc_id
  security_group_name       = var.securiry_group_name_ecs_payment
  ecs_service_name          = var.ecs_service_name_payment
  cluster_id                = module.ecr_repo_payment.cluster_id
  security_groups_ids       = [module.aws_network.security_group_ids]
  subnet_ids                = module.aws_network.subnet_ids
  tags                      = var.settings.tag_default
}

module "ecs_task_definition_order" {
  source                    = "../modules/ecs_task"
  ecs_role_name             = var.ecs_role_name_order
  policy_name               = var.policy_name_order
  excution_role_name        = var.excution_role_name_order
  execution_role_policy     = var.execution_role_policy_order
  family_name               = var.family_name_order
  container_name            = var.container_name_order
  image_url                 = module.ecr_repo_order.repository_url
  cloudwatch_log_group_name = var.cloudwatch_log_group_name_ecr_order
  vpc_id                    = module.aws_network.vpc_id
  security_group_name       = var.securiry_group_name_ecs_order
  ecs_service_name          = var.ecs_service_name_order
  cluster_id                = module.ecr_repo_order.cluster_id
  security_groups_ids       = [module.aws_network.security_group_ids]
  subnet_ids                = module.aws_network.subnet_ids
  tags                      = var.settings.tag_default
}
