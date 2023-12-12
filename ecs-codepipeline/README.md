# ecs-sample
Terraform으로 fargate 기반 ECS 생성

## 사용한 모듈
aws 공식 vpc
- https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
  
aws 공식 보안그룹
- https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/
  
aws 공식 ALB
- https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/

## 구성된 사항
새로운 VPC
- 하나의 NatGateway
- 3개의 서브넷

새로운 ECS 클러스터
- Fargate 기반 컴퓨팅 구성
    + 서비스를 배포 합니다.

새로운 CodeFamily 스택 생성
- CodePipeline V1을 기반한 표준 배포 구성
- CodeCommit(예시 소스) + Codebuild + CodeDeploy + Codepipeline 

## 삭제시 주의사항
S3 버킷에 아티팩트가 남아있어 버킷삭제가 되지 않습니다
- Terraform destoy전 S3 버킷안 오브젝트를 전부 삭제해 주세요