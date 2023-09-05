#---------------------------------------------------------------
# ECS 클러스터 생성
#---------------------------------------------------------------

resource "aws_ecs_cluster" "example" {
  name = local.cluster_name
}

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.example.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 20
    weight            = 50
    capacity_provider = "FARGATE"
  }
  default_capacity_provider_strategy {
    base              = 0
    weight            = 50
    capacity_provider = "FARGATE_SPOT"
  }
}
