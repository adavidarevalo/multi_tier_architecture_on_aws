module "nlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.10.0"

  name               = "backendAlb"
  vpc_id             = var.vpc_id
  subnets            = var.private_subnets
  load_balancer_type = "network"
  security_groups    = [module.private_load_balancer_sg.security_group_id]

  enable_deletion_protection = false
  internal                   = true

  access_logs = {
    bucket = var.monitoring_bucket_id
    prefix = "backEnd-access-logs"
  }

  connection_logs = {
    bucket  = var.monitoring_bucket_id
    enabled = true
    prefix  = "backEndconnection-logs"
  }

  listeners = {
    my-tcp = {
      port     = 80
      protocol = "TCP"
      forward = {
        target_group_key = "backend"
      }
    }
    my-tls = {
      port            = 443
      protocol        = "TLS"
      certificate_arn = var.acm_certificate_arn
      forward = {
        target_group_key = "backend"
      }
    }
  }

  target_groups = {
    backend = {
      create_attachment                 = false
      name                              = "backend"
      protocol                          = "TCP"
      port                              = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = true
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  }
}
