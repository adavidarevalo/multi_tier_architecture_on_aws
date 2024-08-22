module "frontEndASG" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "7.7.0"

  depends_on = [module.alb, module.private_frontend_sg]

  name            = "${var.name}-frontend-asg"
  use_name_prefix = false
  instance_name   = "${var.name}-instance"

  min_size                  = 0
  max_size                  = 2
  desired_capacity          = 1
  wait_for_capacity_timeout = "0"
  default_instance_warmup   = 300
  health_check_type         = "EC2"
  vpc_zone_identifier       = var.private_subnets

  # Traffic source attachment
  create_traffic_source_attachment = true
  traffic_source_identifier        = module.alb.target_groups["frontEndAsg"].arn
  traffic_source_type              = "elbv2"

  # Launch template
  launch_template_name        = "${var.name}-frontend-launchTemplate"
  launch_template_description = "frontEnd Launch Template"
  update_default_version      = true

  key_name = var.key_pair_name

  image_id          = var.ami_id
  instance_type     = var.ec2_intance_type
  user_data         = filebase64("${path.module}/user_data/frontEnd.sh")
  ebs_optimized     = false
  enable_monitoring = true
  security_groups   = [module.private_frontend_sg.security_group_id]

  tags = var.tags

  scaling_policies = {
    avg-cpu-policy-greater-than-50 = {
      policy_type               = "TargetTrackingScaling"
      estimated_instance_warmup = 1200
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 50.0
      }
    }
  }
}
