resource "aws_instance" "jenkins" {
  ami               = var.UbuntuAMI
  instance_type     = var.InstanceType
  availability_zone = var.AvailabilityZone
  subnet_id         = var.rampup_subnet_id
  key_name          = var.key_pair_name
  
  vpc_security_group_ids = [aws_security_group.jenkins_security_group.id]
  user_data              = data.template_file.provisioning.rendered

  tags        = merge(
  { node_type = "control"
    Name = "cmm-rampup-jenkins" },
  var.trainee_tags
  )
  volume_tags = var.trainee_tags

}

data "template_file" "provisioning" {
  template = file("${path.module}/${var.provisioner_file}")
}

resource "aws_security_group" "jenkins_security_group" {
  vpc_id = var.ramp_up_training_id
  tags = merge(
    { Name = "cmm_rampup_jenkins_security_group" },
    var.trainee_tags
  )
}

# This data block is for obtaining the host's IP address
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group_rule" "allow-jenkins-access" {
  type              = "ingress"
  description       = "allow access in port 8080 for jenkins UI"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = [
                        "${chomp(data.http.myip.body)}/32",
                      ] # chomp function is to erase newline characters at the end of the string
  security_group_id = aws_security_group.jenkins_security_group.id
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
  security_group_id = aws_security_group.jenkins_security_group.id
}

resource "aws_security_group_rule" "allow-github-access" {
  type              = "ingress"
  description       = "allow access to github in order to be able to activate github webhooks"
  from_port         = 22
  to_port           = 9418
  protocol          = "tcp"
  cidr_blocks       = var.github_webhook_ipv4
  ipv6_cidr_blocks  = var.github_webhook_ipv6
  security_group_id = aws_security_group.jenkins_security_group.id
}

resource "aws_security_group_rule" "allow-all-egress" {
  type              = "egress"
  description       = "allow all egress for each instance"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_security_group.id
}

data "aws_vpc" "rampup_vpc" {
  id = var.ramp_up_training_id
}