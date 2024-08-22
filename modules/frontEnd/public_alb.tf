module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.10.0"

  name               = "frontEndAlb"
  vpc_id             = var.vpc_id
  subnets            = var.vpc_public_subnets
  load_balancer_type = "application"
  security_groups    = [module.load_balancer_sg.security_group_id]

  enable_deletion_protection = false

  access_logs = {
    bucket = var.monitoring_bucket_id
    prefix = "frontEnd-access-logs"
  }

  connection_logs = {
    bucket  = var.monitoring_bucket_id
    enabled = true
    prefix  = "frontEndconnection-logs"
  }

  listeners = {
    my-http-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = 443
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    my-http-litener = {
      port            = 443
      protocol        = "HTTPS"
      ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
      certificate_arn = var.acm_certificate_arn
      fixed_response = {
        content_type = "text/plain"
        message_body = "Hello World!"
        status_code  = 200
      }
      rules = {
        frontEndAsg = {
          priority = 1
          actions = [{
            type = "weighted-forward"
            target_groups = [
              {
                target_group_key = "frontEndAsg"
                weight           = 1
              }
            ]
            stickiness = {
              enabled  = true
              duration = 3600
            }
          }]
          conditions = [{
            path_pattern = {
              values = ["/*"]
            }
          }]
        }
      }
    }
  }

  target_groups = {
    frontEndAsg = {
      create_attachment                 = false
      name                              = "frontEndAsg"
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = false
      protocol_version                  = "HTTP1"
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