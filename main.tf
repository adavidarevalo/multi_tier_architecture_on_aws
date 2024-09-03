terraform {
  required_version = ">= 1.9.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.58"
    }
  }
  backend "s3" {
    bucket         = "techpulse-store-backend"
    key            = "infra/backend/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "techpulse-store-tfstate-locking"
    encrypt        = true
  }
}


module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = var.vpc_cidr
  azs      = local.azs
  name     = "${local.name}-vpc"
  tags     = local.tags
}

module "hostBastion" {
  source     = "./modules/hostBastion"
  depends_on = [module.vpc]

  key_pair_name = var.hostBastion_key_pair_name

  key_pair_path = local.hostBastion_key_pair_path

  ingress_cidr_blocks = var.hostBastion_ingress_cidr_blocks
  vpc_id              = module.vpc.vpc_id

  tags = local.tags

  ami_id    = local.ami_id
  subnet_id = module.vpc.vpc_public_subnet_ids[0]
}

module "monitoring_bucket_logs" {
  source = "./modules/s3MonitoringLogs"

  name   = "${local.name}-s3"
  tags = local.tags
}

module "frontEnd" {
  source     = "./modules/frontEnd"
  depends_on = [module.vpc, module.monitoring_bucket_logs]

  domain_name = trimsuffix(data.aws_route53_zone.myDomain.name, ".")

  ami_id = data.aws_ami.ec2_ubuntu_ami.id

  ec2_intance_type = var.frontEnd_instance_type

  key_pair_name = var.frontEnd_key_pair_name

  vpc_id = module.vpc.vpc_id

  name            = "${local.name}-frontEnd"
  private_subnets = module.vpc.vpc_private_subnet_ids

  vpc_public_subnets  = module.vpc.vpc_public_subnet_ids
  acm_certificate_arn = module.acm.acm_certificate_arn
  vpc_cidr_block      = module.vpc.vpc_cidr_block

  route53_zone_id      = local.route53_zoneId
  monitoring_bucket_id = module.monitoring_bucket_logs.s3_bucket_id
  tags                 = local.tags
}

module "db" {
  source     = "./modules/database"
  depends_on = [module.vpc]

  vpc_cidr_block = module.vpc.vpc_cidr_block
  tags           = local.tags

  db_rds_name = "${local.name}-_DB"

  vpc_id = module.vpc.vpc_id

  db_instance_type = var.db_instance_type

  db_allocated_storage = var.db_allocated_storage

  db_max_allocated_storage = var.db_max_allocated_storage

  db_name                = var.db_name
  db_instance_identifier = var.db_instance_identifier
  db_username            = var.db_username
  db_password            = var.db_password

  db_subnet_group_name = module.vpc.database_subnet_group

  database_route_table_ids = module.vpc.database_route_table_ids

  vgw_id = module.vpc.vgw_id

  acm_certificate_arn = module.acm.acm_certificate_arn

  database_subnets = module.vpc.database_subnets

  database_subnets_cidr_blocks = module.vpc.database_subnets_cidr_blocks
}

module "backEnd" {

  source     = "./modules/backEnd"
  depends_on = [module.db, module.monitoring_bucket_logs]

  name             = "${local.name}-backEnd"
  ami_id           = local.ami_id
  ec2_intance_type = var.backEnd_instance_type

  db_instance_domain = module.db.db_instance_domain

  db_password = var.db_password

  db_instance_username = module.db.db_instance_username
  db_instance_name     = module.db.db_instance_name
  tags                 = local.tags
  key_pair_name        = var.backEnd_key_pair_name
  vpc_id               = module.vpc.vpc_id
  vpc_cidr_block       = module.vpc.vpc_cidr_block

  private_subnets      = module.vpc.vpc_private_subnet_ids
  acm_certificate_arn  = module.acm.acm_certificate_arn
  monitoring_bucket_id = module.monitoring_bucket_logs.s3_bucket_id
}