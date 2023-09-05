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
    + Fargate: defuault 20% max 50%
    + Fargate_spot: max 50%

ECS 데모 App 서비스 배포
- AWS 워크샵 ecs-demo 앱 사용 
    + app이 배포된 AZ를 확인가능한 간단한 웹페이지
    + URL: public.ecr.aws/aws-containers/ecsdemo-frontend:776fd50 

## 특이사항
- 데모 App의 경우 전부 Private의 배포 ingress 트래픽의 경우 ALB만 허용
- 컨테이너 image pull시 Natgateway 통해서 진행 하도록

## 아직 추가되지 않은 사항
- output: ALB 접근 도메인
- route53 도메인 ALB 레코드 등록
- ACM 인증서 발급 및 ALB 연결