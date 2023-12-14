## 배포시 appspec.yaml 및 TaskDefinition 정보에 들어갑니다.
variable "container-name" {
  type    = string
  default = "ecs-example"
}

variable "container-port" {
  type    = number
  default = 80
}

## TaskDefinition과 CodeDeploy에서 사용됩니다.
variable "definition-name" {
  type    = string
  default = "example-definition"
}

## ECR 레포 이름 
variable "ecr-repo-name" {
  type    = string
  default = "example-ecr-repo"
}

## CodeCommit 레포 이름
variable "codecommit-repo-name" {
  type    = string
  default = "example-codecommit-repo"
}

## CodeBuild 프로젝트 이름
variable "codebuild-project-name" {
  type    = string
  default = "example-project"
}