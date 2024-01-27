## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api_gateway"></a> [api\_gateway](#module\_api\_gateway) | ../modules/api_gateway | n/a |
| <a name="module_api_integration"></a> [api\_integration](#module\_api\_integration) | ../modules/api_integration | n/a |
| <a name="module_aws_dynamo"></a> [aws\_dynamo](#module\_aws\_dynamo) | ../modules/dynamo | n/a |
| <a name="module_aws_network"></a> [aws\_network](#module\_aws\_network) | ../modules/network | n/a |
| <a name="module_aws_rds_order"></a> [aws\_rds\_order](#module\_aws\_rds\_order) | ../modules/rds | n/a |
| <a name="module_aws_rds_payment"></a> [aws\_rds\_payment](#module\_aws\_rds\_payment) | ../modules/rds | n/a |
| <a name="module_ecr_repo"></a> [ecr\_repo](#module\_ecr\_repo) | ../modules/ecr | n/a |
| <a name="module_ecs_task_definition"></a> [ecs\_task\_definition](#module\_ecs\_task\_definition) | ../modules/ecs_task | n/a |
| <a name="module_lambda"></a> [lambda](#module\_lambda) | ../modules/lambda | n/a |
| <a name="module_sqs_queue_create_order"></a> [sqs\_queue\_create\_order](#module\_sqs\_queue\_create\_order) | ../modules/sqs | n/a |
| <a name="module_sqs_queue_update_order"></a> [sqs\_queue\_update\_order](#module\_sqs\_queue\_update\_order) | ../modules/sqs | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_authorization"></a> [api\_authorization](#input\_api\_authorization) | API Authorization | `string` | `"NONE"` | no |
| <a name="input_api_name"></a> [api\_name](#input\_api\_name) | Nome da API | `string` | `"fiap"` | no |
| <a name="input_billing_mode"></a> [billing\_mode](#input\_billing\_mode) | Billing mode | `string` | `"PAY_PER_REQUEST"` | no |
| <a name="input_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#input\_cloudwatch\_log\_group\_name) | Log name | `string` | `"app"` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | Container Name | `string` | `"container_name"` | no |
| <a name="input_create_order_delay_seconds"></a> [create\_order\_delay\_seconds](#input\_create\_order\_delay\_seconds) | Delay in seconds | `number` | `1` | no |
| <a name="input_create_order_message_size"></a> [create\_order\_message\_size](#input\_create\_order\_message\_size) | max message size | `number` | `2048` | no |
| <a name="input_create_order_name"></a> [create\_order\_name](#input\_create\_order\_name) | Order Name | `string` | `"create_order"` | no |
| <a name="input_create_order_retention_seconds"></a> [create\_order\_retention\_seconds](#input\_create\_order\_retention\_seconds) | Retention Seconds | `number` | `86400` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Password do banco | `string` | n/a | yes |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | DB Group name | `string` | `"fiap"` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Username do Banco | `string` | n/a | yes |
| <a name="input_dynamo_table_name"></a> [dynamo\_table\_name](#input\_dynamo\_table\_name) | Nome do tabela | `string` | `"FIAP"` | no |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | Cluster Name | `string` | `"app_cluster"` | no |
| <a name="input_ecs_role_name"></a> [ecs\_role\_name](#input\_ecs\_role\_name) | ECS Role Name | `string` | `"ecs_role"` | no |
| <a name="input_ecs_service_name"></a> [ecs\_service\_name](#input\_ecs\_service\_name) | ECS Service Name | `string` | `"app-service"` | no |
| <a name="input_excution_role_name"></a> [excution\_role\_name](#input\_excution\_role\_name) | Execution Role Name | `string` | `"execution_role"` | no |
| <a name="input_execution_role_policy"></a> [execution\_role\_policy](#input\_execution\_role\_policy) | Execution Role Policy | `string` | `"execution_role_policy"` | no |
| <a name="input_family_name"></a> [family\_name](#input\_family\_name) | Family Name | `string` | `"app"` | no |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | Chave da hash de criptografia do banco | `string` | `"ID"` | no |
| <a name="input_http_method"></a> [http\_method](#input\_http\_method) | Metodo HTTP da API | `string` | `"ANY"` | no |
| <a name="input_integration_http_method"></a> [integration\_http\_method](#input\_integration\_http\_method) | HTTP Method | `string` | `"POST"` | no |
| <a name="input_integration_type"></a> [integration\_type](#input\_integration\_type) | Integration Type | `string` | `"AWS_PROXY"` | no |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | Policy Name | `string` | `"ecs_policy_name"` | no |
| <a name="input_public_subnet_cidr_blocks"></a> [public\_subnet\_cidr\_blocks](#input\_public\_subnet\_cidr\_blocks) | CIDR blocks for public subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_respository_name"></a> [respository\_name](#input\_respository\_name) | Repo name | `string` | `"app_repo"` | no |
| <a name="input_securiry_group_name"></a> [securiry\_group\_name](#input\_securiry\_group\_name) | Security Group name | `string` | `"FIAP-RDS"` | no |
| <a name="input_settings"></a> [settings](#input\_settings) | Settings for the RDS | `map(any)` | <pre>{<br>  "database": {<br>    "allocated_storage": 20,<br>    "db_name": "fiap_db",<br>    "db_port": 3306,<br>    "engine": "mysql",<br>    "engine_version": "8.0.33",<br>    "identifier": "fiap-db",<br>    "instance_class": "db.t2.micro",<br>    "multi_az": false,<br>    "publicly_accessible": true,<br>    "skip_final_snapshot": true<br>  },<br>  "lambda": {<br>    "filename": "lambda.zip",<br>    "function_name": "fiap-auth",<br>    "handler": "index.handler",<br>    "runtime": "nodejs18.x"<br>  },<br>  "subnet": {<br>    "count": 2,<br>    "map_public_ip_on_launch": true<br>  },<br>  "tag_default": {<br>    "name": "fiap"<br>  }<br>}</pre> | no |
| <a name="input_stage_deploy"></a> [stage\_deploy](#input\_stage\_deploy) | Stage Deploy | `string` | `"prod"` | no |
| <a name="input_stage_name"></a> [stage\_name](#input\_stage\_name) | Stage Name | `string` | `"fiap"` | no |
| <a name="input_update_order_delay_seconds"></a> [update\_order\_delay\_seconds](#input\_update\_order\_delay\_seconds) | Delay in seconds | `number` | `1` | no |
| <a name="input_update_order_message_size"></a> [update\_order\_message\_size](#input\_update\_order\_message\_size) | max message size | `number` | `2048` | no |
| <a name="input_update_order_name"></a> [update\_order\_name](#input\_update\_order\_name) | Update Name | `string` | `"update_order"` | no |
| <a name="input_update_order_retention_seconds"></a> [update\_order\_retention\_seconds](#input\_update\_order\_retention\_seconds) | Retention Seconds | `number` | `86400` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | CIDR block for VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
