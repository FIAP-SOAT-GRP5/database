module "aws_network" {
  source                    = "../modules/network"
  subnet_count              = var.settings.subnet.count
  vpc_cidr_block            = var.vpc_cidr_block
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  map_public_ip_on_launch   = var.settings.subnet.map_public_ip_on_launch
  tags                      = var.settings.tag_default.name
  securiry_group_name       = var.securiry_group_name
  from_db_port              = var.settings.database.db_port
  to_db_port                = var.settings.database.db_port
}

module "aws_rds_order" {
  source               = "../modules/rds"
  db_subnet_group_name = var.db_subnet_group_name
  subnet_ids           = module.aws_network.subnet_ids
  allocated_storage    = var.settings.database.allocated_storage
  db_name              = var.settings.database.db_name
  engine               = var.settings.database.db_name
  engine_version       = var.settings.database.engine
  instance_class       = var.settings.database.instance_class
  db_username          = var.db_username
  db_password          = var.db_password
  skip_final_snapshot  = var.settings.database.skip_final_snapshot
  publicly_accessible  = var.settings.database.publicly_accessible
  multi_az             = var.settings.database.multi_az
  identifier           = var.settings.database.identifier
  security_group_ids   = module.aws_network.security_group_ids
  db_port              = var.settings.database.db_port
  tags                 = var.settings.tag_default.name
}

module "aws_rds_payment" {
  source               = "../modules/rds"
  db_subnet_group_name = var.db_subnet_group_name
  subnet_ids           = module.aws_network.subnet_ids
  allocated_storage    = var.settings.database.allocated_storage
  db_name              = var.settings.database.db_name
  engine               = var.settings.database.db_name
  engine_version       = var.settings.database.engine
  instance_class       = var.settings.database.instance_class
  db_username          = var.db_username
  db_password          = var.db_password
  skip_final_snapshot  = var.settings.database.skip_final_snapshot
  publicly_accessible  = var.settings.database.publicly_accessible
  multi_az             = var.settings.database.multi_az
  identifier           = var.settings.database.identifier
  security_group_ids   = module.aws_network.security_group_ids
  db_port              = var.settings.database.db_port
  tags                 = var.settings.tag_default.name
}

module "aws_dynamo" {
  source            = "../modules/dynamo"
  dynamo_table_name = var.dynamo_table_name
  billing_mode      = var.billing_mode
  hash_key          = var.hash_key
  tags              = var.settings.tag_default.name
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
  rest_api_id             = module.api_gateway.resource_id
  integration_http_method = var.integration_http_method
  integration_type        = var.integration_type
  uri                     = module.lambda.invoke_arn
  method_id               = module.api_gateway.http_id
  stage_deploy            = var.stage_deploy
  stage_name              = var.stage_name
  tags                    = var.settings.tag_default.name
}
# SQS queue para cada microservico
module "sqs_queue_create_order" {
  source                    = "../modules/sqs"
  sqs_queue_name            = var.create_order_name
  delay_seconds             = var.create_order_delay_seconds
  max_message_size          = var.create_order_message_size
  message_retention_seconds = var.create_order_retention_seconds
  tags                      = var.settings.tag_default.name
}

module "sqs_queue_update_order" {
  source                    = "../modules/sqs"
  sqs_queue_name            = var.update_order_name
  delay_seconds             = var.update_order_delay_seconds
  max_message_size          = var.update_order_message_size
  message_retention_seconds = var.update_order_retention_seconds
  tags                      = var.settings.tag_default.name
}

module "ecr_repo" {
  source                    = "../modules/ecr"
  cloudwatch_log_group_name = var.cloudwatch_log_group_name
  respository_name          = var.respository_name
  ecs_cluster_name          = var.ecs_cluster_name
  tags                      = var.settings.tag_default.name
}

module "ecs_task_definition" {
  source                    = "../modules/ecs_task"
  ecs_role_name             = var.ecs_role_name
  policy_name               = var.policy_name
  excution_role_name        = var.excution_role_name
  execution_role_policy     = var.execution_role_policy
  family_name               = var.family_name
  container_name            = var.container_name
  image_url                 = module.ecr_repo.repository_url
  cloudwatch_log_group_name = var.cloudwatch_log_group_name
  vpc_id                    = module.aws_network.vpc_id
  security_group_name       = module.aws_network.securiry_group_name
  ecs_service_name          = var.ecs_service_name
  cluster_id                = module.ecr_repo.cluster_id
  security_groups_ids       = module.aws_network.security_group_ids
  subnet_ids                = module.aws_network.subnet_ids
  tags                      = var.settings.tag_default.name
}