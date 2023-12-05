## 배포시 appspec.yaml 및 TaskDefinition 정보에 들어갑니다.
variable "container-name" {
  type    = string
  default = "ecs-php"
}

variable "container-port" {
  type    = number
  default = 80
}

## TaskDefinition과 CodeDeploy에서 사용됩니다.
variable "task-name" {
  type    = string
  default = "example-task"
}