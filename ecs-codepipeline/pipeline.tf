#---------------------------------------------------------------
# Code 시리즈 리소스 생성
#---------------------------------------------------------------

# CodeCommit 레포 생성
resource "aws_codecommit_repository" "my_repo" {
  repository_name = "${var.codecommit-repo-name}"
  default_branch = "main"
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
  name          = "example-project"

  build_timeout = 5
  service_role  = aws_iam_role.codebuild_role.arn
  
  artifacts {
    type = "S3"
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

# CodeDeplouy


# CodePipeline

