module "hostBastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.1"

  depends_on = [module.hostBastion_sg]

  ami           = var.ami_id
  instance_type = "t2.micro"

  subnet_id = var.subnet_id

  vpc_security_group_ids = [module.hostBastion_sg.security_group_id]

  key_name = var.key_pair_name

  user_data = file("${path.module}/user_data/host_bastion.sh")

  tags = {
    Name = "hostBastion"
  }
}

resource "aws_eip" "hostBastion_eip" {
  depends_on = [module.hostBastion]
  instance   = module.hostBastion.id
  domain     = "vpc"
}