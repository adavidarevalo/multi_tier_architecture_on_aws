resource "aws_route53_record" "apps_dns" {
  zone_id = var.route53_zone_id
  name    = "dev.${var.domain_name}"
  type    = "A"
  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }
}
