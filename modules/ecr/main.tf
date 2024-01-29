resource "aws_cloudwatch_log_group" "app" {
  name = var.cloudwatch_log_group_name
  tags = var.tags
}

resource "aws_ecr_repository" "ecr_app" {
  name = var.respository_name
  force_delete = true

  tags = var.tags

}

resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster_name

  tags = var.tags
}
