#---------------------------------------------------------------
# Code 시리즈 리소스 생성
#---------------------------------------------------------------

# CodeCommit 레포 생성
resource "aws_codecommit_repository" "my_repo" {
  repository_name = var.codecommit-repo-name
  default_branch  = "main"
}

# 빌드시 아티팩트를 저장할 S3 버킷 생성
resource "aws_s3_bucket" "s3_bucket" {
  bucket_prefix = "ecs-codepipeline-example-"
}
# resource "aws_s3_bucket_acl" "s3_bucket_acl" {
#   bucket = aws_s3_bucket.s3_bucket.id
#   acl    = "private"
# }

# Codebuild 프로젝트 생성
resource "aws_codebuild_project" "example" {
  name = var.codebuild-project-name

  build_timeout = 5
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type     = "S3"
    location = aws_s3_bucket.s3_bucket.id
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  # CodeCommit 소스를 기반으로 빌드
  source {
    type            = "CODECOMMIT"
    location        = aws_codecommit_repository.my_repo.clone_url_http
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }
  source_version = "main"
}

# CodeDeploy Application
resource "aws_codedeploy_app" "example" {
  compute_platform = "ECS"
  name             = "ecs-example"
}
# CodeDeploy DeployGroup
resource "aws_codedeploy_deployment_group" "example" {
  app_name               = aws_codedeploy_app.example.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "ecs-example"
  service_role_arn       = aws_iam_role.codedeploy_role.arn

  blue_green_deployment_config {

    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 1
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.example.name
    service_name = aws_ecs_service.example.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [element(module.alb.http_tcp_listener_arns, 0)]
      }
      # Blue TargetGroup
      target_group {
        name = element(module.alb.target_group_names, 0)
      }
      # Green TargetGroup
      target_group {
        name = element(module.alb.target_group_names, 1)
      }
    }
  }
}

# CodePipeline 
resource "aws_codepipeline" "codepipeline" {
  name     = "example-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.s3_bucket.bucket
    type     = "S3"
  }

  ## 스테이지 구성 정보 Docs
  ## https://docs.aws.amazon.com/ko_kr/codepipeline/latest/userguide/action-reference-CodeCommit.html
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["Source_Artifact"]

      configuration = {
        RepositoryName       = aws_codecommit_repository.my_repo.repository_name
        BranchName           = "main"
        PollForSourceChanges = false
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  ## 스테이지 구성 정보 Docs
  ## https://docs.aws.amazon.com/ko_kr/codepipeline/latest/userguide/action-reference-CodeBuild.html
  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["Source_Artifact"]
      output_artifacts = ["Build_Artifact"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.example.name
      }
    }
  }

  ## 스테이지 구성 정보 Docs
  ## https://docs.aws.amazon.com/ko_kr/codepipeline/latest/userguide/action-reference-CodeDeploy.html
  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["Build_Artifact"]
      version         = "1"

      configuration = {
        ApplicationName     = aws_codedeploy_app.example.name
        DeploymentGroupName = aws_codedeploy_deployment_group.example.deployment_group_name
      }
    }
  }
}