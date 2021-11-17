resource "aws_lb" "application_load_balancer" {
  name               = "cmm-${var.server_type}-load-balancer"
  internal           = var.internal_facing_lb_value
  load_balancer_type = "application"
  ip_address_type = "ipv4"
  subnets            = [var.rampup_subnet_id, var.rampup_subnet_id_2]   # list with public subnets for front and private subnets for back
  security_groups    = [aws_security_group.load_balancer_security_group.id]
  #tags are defined on root main tf file
}

resource "aws_security_group" "load_balancer_security_group" {
  vpc_id = data.aws_vpc.rampup_vpc.id
  tags = merge(
    { Name = "${var.server_type}_rampup_security_group" },
    var.trainee_tags
  )
}

resource "aws_security_group_rule" "allow-tier-access" {
  type              = "ingress"
  description       = "allow access in each instance selected port, 3030 for front, 3000 for back"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.load_balancer_security_group.id
}

resource "aws_security_group_rule" "allow-http-access" {
  type              = "ingress"
  description       = "allow access in 80 port for http, in order to redirect requests"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.load_balancer_security_group.id
}

# This data block is for obtaining the host's IP address
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group_rule" "allow-ssh-access" {
  type              = "ingress"
  description       = "allow access in port 22 to ssh from host ip"
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  protocol          = "tcp"
  cidr_blocks       = [
                        "${chomp(data.http.myip.body)}/32",
                        data.aws_vpc.rampup_vpc.cidr_block
                      ] # chomp function is to erase newline characters at the end of the string
  security_group_id = aws_security_group.load_balancer_security_group.id
}

resource "aws_security_group_rule" "allow-all-egress" {
  type              = "egress"
  description       = "allow all egress for each instance"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.load_balancer_security_group.id
}

data "aws_vpc" "rampup_vpc" {
  id = var.ramp_up_training_id
}