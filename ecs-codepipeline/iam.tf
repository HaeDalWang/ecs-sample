#---------------------------------------------------------------
# IAM Role 및 Policy 리소스
#---------------------------------------------------------------

## Task Role (ECR 이미지 허용)
resource "aws_iam_role" "task_role" {
  name = "ecsTaskExecutionRole-example"

  assume_role_policy = jsonencode({
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "ecs-tasks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
}

## CodeBuild Service Role
resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-ecs-service-role-example"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "codebuild.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"]
}
