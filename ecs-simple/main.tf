#---------------------------------------------------------------
# 프로바이더 및 로컬 변수 지정
#---------------------------------------------------------------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.10.0"
    }
  }
}

provider "aws" {
  region = local.region
}

locals {
  cluster_name = "example-ecs-cluster"

  region = "ap-northeast-2"

  tags = {
    Terraform = "true"
  }


}