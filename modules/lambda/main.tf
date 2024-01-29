resource "aws_lambda_function" "fiap" {
  filename         = var.filename
  function_name    = var.function_name
  handler          = var.handler
  runtime          = var.runtime
  role             = aws_iam_role.fiap.arn
  source_code_hash = filebase64sha256(var.filename)
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fiap.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = var.source_arn
}
