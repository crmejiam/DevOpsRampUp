resource "aws_lb_target_group" "tier_target_group" {
  name     = "cmm-rampup-${var.server_type}-target-group"
  port     = var.port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.rampup_vpc.id
}

resource "aws_lb_listener" "main_port_access" {
  load_balancer_arn = var.application_load_balancer_arn
  port              = var.port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tier_target_group.arn
  }
}

resource "aws_lb_listener" "port_80_redirect" {
  load_balancer_arn = var.application_load_balancer_arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "3030"
      protocol    = "HTTP"
      status_code = "HTTP_301"
    }
  }
}

data "aws_vpc" "rampup_vpc" {
  id = var.ramp_up_training_id
}