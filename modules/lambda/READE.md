## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.fiap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_lambda_function.fiap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.apigw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_filename"></a> [filename](#input\_filename) | Path to the function's deployment package within the local filesystem. | `string` | n/a | yes |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Unique name for your Lambda Function. | `string` | n/a | yes |
| <a name="input_handler"></a> [handler](#input\_handler) | Function entrypoint in your code. | `string` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Identifier of the function's runtime. | `string` | n/a | yes |
| <a name="input_source_arn"></a> [source\_arn](#input\_source\_arn) | When the principal is an AWS service, the ARN of the specific resource within that service to grant permission to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_invoke_arn"></a> [invoke\_arn](#output\_invoke\_arn) | n/a |
