resource "aws_autoscaling_group" "app_autoscaling_groups" {
  name = "cmm-rampup-${var.server_type}-autoscaling-group"
  vpc_zone_identifier = [var.subnet_id]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  health_check_grace_period = 30
  target_group_arns = [ data.aws_lb_target_group.tier_target_group.arn ]
  
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
    id      = data.aws_launch_template.tier_launch_template.id
    version = "$Latest"
  }
}

data "aws_launch_template" "tier_launch_template" {
  name = "cmm-rampup-${var.server_type}-launch-template"
  tags = merge(
    { tier = var.server_type },
    var.trainee_tags
  )
}

data "aws_lb_target_group" "tier_target_group" {
  name = "cmm-rampup-${var.server_type}-target-group"
}