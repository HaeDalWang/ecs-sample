#---------------------------------------------------------------
# VPC 생성
# aws 공식 vpc 모듈 사용
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
#---------------------------------------------------------------

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.4.0"
  name    = local.cluster_name

  # 가용 영역 및 서브넷 cidr
  cidr            = "10.222.0.0/16"
  azs             = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
  public_subnets  = ["10.222.10.0/24", "10.222.20.0/24", "10.222.30.0/24"]
  private_subnets = ["10.222.110.0/24", "10.222.120.0/24", "10.222.130.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags
}