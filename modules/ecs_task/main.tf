resource "aws_ecs_task_definition" "app" {
  family = var.family_name
  container_definitions = jsonencode([{
    name  = var.container_name
    image = var.image_url
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
      protocol      = "tcp"
    }]
    essential = true
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = var.cloudwatch_log_group_name
        awslogs-region        = "us-east-1"
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_execution_role.arn

  tags = var.tags
}

resource "aws_security_group" "ecs_service" {
  vpc_id      = var.vpc_id
  name        = var.security_group_name
  description = "Allow egress from container"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_ecs_service" "app" {
  name            = var.ecs_service_name
  task_definition = "${aws_ecs_task_definition.app.family}:${max("${aws_ecs_task_definition.app.revision}", "${data.aws_ecs_task_definition.app.revision}")}"
  desired_count   = 1
  launch_type     = "FARGATE"
  cluster         = var.cluster_id
  depends_on      = [aws_iam_role_policy.ecs_service_role_policy]

  network_configuration {
    security_groups  = [for sg in flatten(concat(var.security_groups_ids, [aws_security_group.ecs_service.id])) : sg]
    subnets          = var.subnet_ids
    assign_public_ip = true
  }

  tags = var.tags
}


