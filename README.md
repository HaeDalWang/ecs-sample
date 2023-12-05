# ecs-sample
Terraform으로 ECS 생성

## 폴더 예시
- ecs-simple
    + Fargate 기반으로 MultiAZ로 배포 되는 간단한 '서비스'를 배포 합니다.
    + ALB Endpoint로 접근하여 새로고침시 AZ로 어떻게 밸런싱 되는지 확인 합니다.
- ecs-codepipeline
    + ecs에 배포를 Codepipeline과 통합합니다
    + CodeDeploy를 통해 블루/그린 방식으로 ECS에 '서비스'를 배포합니다.
    + CodeCommit에 간단한 apache + php 소스코드를 사용합니다.
    + CodeCommit 수정 시 파이프라인이 작동하여 배포하도록 구성됩니다. ALB Endpoint을 통해 변경사항을 확인 합니다.
