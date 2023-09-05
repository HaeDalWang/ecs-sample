#---------------------------------------------------------------
# ECS 클러스터 생성
# https://registry.terraform.io/modules/terraform-aws-modules/ecs/aws/5.2.2?utm_content=documentLink&utm_medium=Visual+Studio+Code&utm_source=terraform-ls
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