resource "aws_ecs_task_definition" "service" {
  family                   = "our_backend"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode([
    {
      name      = "our_backend"
      image     = var.image
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])

  execution_role_arn = aws_iam_role.task_role.arn
  network_mode       = "awsvpc"
}


resource "aws_ecs_service" "our_backend" {
  name            = "our_backend"
  launch_type     = "FARGATE"
  cluster         = aws_ecs_cluster.main_cluster.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 1

  network_configuration {
    assign_public_ip = true
    subnets          = data.aws_subnets.deployment_subnets.ids
    security_groups  = [aws_security_group.backend_sg.id]
  }
}


resource "aws_iam_role" "task_role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  inline_policy {
    name = "ecr_pull"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          Resource = "*"
        }
      ]
    })
  }
}
