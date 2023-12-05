# #---------------------------------------------------------------
# # 서비스와 연결할 ALB + 보안그룹 구성
# #---------------------------------------------------------------

module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${var.container-name}-service"
  description = "${var.container-name} Service security group"
  vpc_id      = module.vpc.vpc_id

  ingress_rules       = ["http-80-tcp","https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules = ["all-all"]

  tags = local.tags
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = var.container-name

  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.alb_sg.security_group_id]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    },
  ]

  target_groups = [
    {
      name             = "${var.container-name}"
      backend_protocol = "HTTP"
      backend_port     = var.container-port
      target_type      = "ip"
    },
  ]

  tags = local.tags
}