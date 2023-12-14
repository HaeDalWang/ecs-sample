## buidlspec.yaml
## ECR 레포 주소
output "ecr-repo" {
  description = "ECR Repository 주소"
  value       = element(split("/","${aws_ecr_repository.example-repo.repository_url}"),0)
}
## ECR 레포 URI
output "ecr-repo-uri" {
  description = "ECR Repository URL"
  value       = aws_ecr_repository.example-repo.repository_url
}

## appspec.yaml
## Task 정의 ARN
output "taskdef-arn" {
  description = "Task 정의 Arn"
  value       = aws_ecs_task_definition.example.arn
}

## Container Name
## Contianer 포트
output "container-name-port" {
  description = "Container 이름/port"
  value       = {
    name = var.container-name
    port = var.container-port
  }
}

## 서브넷 ID
## SG ID
output "network-info" {
  description = "VPC Subnet and SecurityGroup"
  value       = {
    SubnetsID = module.vpc.private_subnets
    SecurityGroupID = aws_security_group.demo.id
  }
}

## CodeCommmit Repo url
output "codecommit-url" {
  description = "CodeCommit Repository URL"
  value       = aws_codecommit_repository.my_repo.clone_url_http
}
