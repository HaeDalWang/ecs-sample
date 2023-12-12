#---------------------------------------------------------------
# ECR 레포지토리 생성
# 빌드 된 컨테이너가 저장됩니다.
#---------------------------------------------------------------

resource "aws_ecr_repository" "example-repo" {
  name = var.ecr-repo-name
  ## 태그 변경 가능성 IMMUTABLE, MUTABLE
  image_tag_mutability = "MUTABLE"
  ## push할떄 Scan하여 보안 검사
  image_scanning_configuration {
    scan_on_push = false
  }
}