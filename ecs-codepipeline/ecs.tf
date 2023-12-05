#---------------------------------------------------------------
# ECS 클러스터 생성
#---------------------------------------------------------------

resource "aws_ecs_cluster" "example" {
  name = local.cluster_name
}

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.example.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}
