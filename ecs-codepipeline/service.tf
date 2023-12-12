#---------------------------------------------------------------
# ECS 서비스 생성 
#---------------------------------------------------------------

# 작업 정의 생성
resource "aws_ecs_task_definition" "example" {
  family                   = var.definition-name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 2048
  memory                   = 4096
  execution_role_arn       = aws_iam_role.task_role.arn

  container_definitions = jsonencode([
    {
      name      = "${var.container-name}"
      image     = "${aws_ecr_repository.example-repo.repository_url}:latest"
      cpu       = 512
      memory    = 1024
      essential = true
      portMappings = [
        {
          containerPort = var.container-port
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

# 서비스가 사용할 보안그룹
# ingress: ALB 보안그룹, egress: All
resource "aws_security_group" "demo" {
  name        = "allow_alb"
  description = "Allow ALB inbound traffic"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description     = "http from alb"
    from_port       = var.container-port
    to_port         = var.container-port
    protocol        = "tcp"
    security_groups = ["${module.alb_sg.security_group_id}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 서비스 생성
resource "aws_ecs_service" "example" {
  name            = var.container-name
  cluster         = aws_ecs_cluster.example.arn
  task_definition = aws_ecs_task_definition.example.arn
  desired_count   = 3

  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = ["${aws_security_group.demo.id}"]
  }

  load_balancer {
    target_group_arn = element(module.alb.target_group_arns, 0)
    container_name   = var.container-name
    container_port   = var.container-port
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }
}