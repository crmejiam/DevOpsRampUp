resource "aws_launch_template" "app_launch_templates" {
  name = "cmm-rampup-${var.server_type}-launch-template"
  # tags are defined on root tf directory
  image_id      = var.UbuntuAMI
  instance_type = var.InstanceType
  key_name = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.launch_template_security_group.id]

  tag_specifications {
    resource_type = "instance"
    tags = var.trainee_tags
  }

  tag_specifications {
    resource_type = "volume"
    tags = var.trainee_tags
  }

  tag_specifications {
    resource_type = "network-interface"
    tags = var.trainee_tags
  }

  user_data = base64encode(data.template_file.provisioning.rendered)
}

data "template_file" "provisioning" {
  template = file("${path.module}/scripts/${var.provisioner_file}")
  vars     = {
    control_node_ip = var.control_node_ip
    control_node_port = var.control_node_port
    server_type = var.server_type
  }
}

resource "aws_security_group" "launch_template_security_group" {
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
  security_group_id = aws_security_group.launch_template_security_group.id
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
  security_group_id = aws_security_group.launch_template_security_group.id
}

resource "aws_security_group_rule" "allow-all-egress" {
  type              = "egress"
  description       = "allow all egress for each instance"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.launch_template_security_group.id
}

data "aws_vpc" "rampup_vpc" {
  id = var.ramp_up_training_id
}