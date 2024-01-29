resource "aws_iam_role" "ecs_role" {
  name               = var.ecs_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_service_role.json

  tags = var.tags

}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = var.policy_name
  policy = data.aws_iam_policy_document.ecs_service_policy.json
  role   = aws_iam_role.ecs_role.id
}

resource "aws_iam_role" "ecs_execution_role" {
  name               = var.excution_role_name
  assume_role_policy = file("${path.module}/policies/ecs-task-execution-role.json")

  tags = var.tags
}
resource "aws_iam_role_policy" "ecs_execution_role_policy" {
  name   = var.execution_role_policy
  policy = file("${path.module}/policies/ecs-execution-role-policy.json")
  role   = aws_iam_role.ecs_execution_role.id
}