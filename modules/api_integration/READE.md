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
| [aws_api_gateway_deployment.fiap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_integration.fiap_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_stage.fiap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_http_method"></a> [http\_method](#input\_http\_method) | HTTP method (GET, POST, PUT, DELETE, HEAD, OPTION, ANY) when calling the associated resource. | `string` | n/a | yes |
| <a name="input_integration_http_method"></a> [integration\_http\_method](#input\_integration\_http\_method) | (Optional) Integration HTTP method (GET, POST, PUT, DELETE, HEAD, OPTIONs, ANY, PATCH) specifying how API Gateway will interact with the back end. | `string` | n/a | yes |
| <a name="input_integration_type"></a> [integration\_type](#input\_integration\_type) | (Required) Integration input's type. Valid values are HTTP (for HTTP backends), MOCK (not calling any real backend), AWS (for AWS services), AWS\_PROXY (for Lambda proxy integration) and HTTP\_PROXY (for HTTP proxy integration). | `string` | n/a | yes |
| <a name="input_method_id"></a> [method\_id](#input\_method\_id) | ID used in Method HTTP | `string` | n/a | yes |
| <a name="input_resource_id"></a> [resource\_id](#input\_resource\_id) | (Required) API resource ID. | `string` | n/a | yes |
| <a name="input_rest_api_id"></a> [rest\_api\_id](#input\_rest\_api\_id) | (Required) ID of the associated REST API. | `string` | n/a | yes |
| <a name="input_stage_deploy"></a> [stage\_deploy](#input\_stage\_deploy) | (Optional) Name of the stage to create with this deployment. | `string` | n/a | yes |
| <a name="input_stage_name"></a> [stage\_name](#input\_stage\_name) | (Required) Name of the stage | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Map of tags to assign to the resource. | `any` | n/a | yes |
| <a name="input_uri"></a> [uri](#input\_uri) | (Optional) Input's URI. Required if type is AWS, AWS\_PROXY, HTTP or HTTP\_PROXY. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_gateway_url"></a> [api\_gateway\_url](#output\_api\_gateway\_url) | n/a |
