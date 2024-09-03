module "rdsDb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "${var.db_rds_name}-sg"
  description = "Access to MySQL DB for entire VPC CIDR Block"
  vpc_id      = var.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL access from within VPC"
      cidr_blocks = var.vpc_cidr_block
    }
  ]


  egress_rules = ["all-all"]

  tags = merge(var.tags, {
    Name = "${var.db_rds_name}-sg"
  })
}

