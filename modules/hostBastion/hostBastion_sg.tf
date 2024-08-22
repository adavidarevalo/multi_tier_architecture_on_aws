module "hostBastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "hostBastion_sg"
  description = "Http open for the internet"
  vpc_id      = var.vpc_id

  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = var.ingress_cidr_blocks

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

  tags = merge(var.tags, {
    Name = "hostBastion_sg"
  })
}

