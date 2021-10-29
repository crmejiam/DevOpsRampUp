resource "aws_autoscaling_group" "app_autoscaling_groups" {
  name = "cmm-rampup-${var.server_type}-autoscaling-group"
  vpc_zone_identifier = [var.subnet_id]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  health_check_grace_period = 30
  target_group_arns = [ var.tier_target_group_arn ]
  
  tag {
    key = "project"
    value = "ramp-up-devops"
    propagate_at_launch = true
  }

  tag {
    key = "responsible"
    value = "cristian.mejiam"
    propagate_at_launch = true
  }

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }
}