resource "aws_instance" "control_node" {
  ami               = var.UbuntuAMI
  instance_type     = var.InstanceType
  availability_zone = var.AvailabilityZone
  subnet_id         = var.rampup_subnet_id
  key_name          = aws_key_pair.key-pair.key_name
  
  vpc_security_group_ids = [aws_security_group.control_security_group.id]
  user_data              = data.template_file.provisioning.rendered

  tags        = merge(
  { node_type = "control"
    Name = "cmm-rampup-control-node-ansible" },
  var.trainee_tags
  )
  volume_tags = var.trainee_tags

}

resource "tls_private_key" "private-key-generator" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key-pair" {
  key_name   = var.key_pair_name       # Create a key pair to AWS
  public_key = tls_private_key.private-key-generator.public_key_openssh
}

resource "local_file" "pem_file" {
  filename = pathexpand("C:/Users/cristian.mejiam/Desktop/cmm-rampup-key-ansible.pem")
  file_permission = "600"
  directory_permission = "700"
  sensitive_content = tls_private_key.private-key-generator.private_key_pem
}

data "template_file" "provisioning" {
  template = file("${path.module}/${var.provisioner_file}")
  vars     = merge(
  { key-pair = tls_private_key.private-key-generator.private_key_pem },  
  var.env_variables
  )
}

resource "aws_security_group" "control_security_group" {
  vpc_id = var.ramp_up_training_id
  tags = merge(
    { Name = "cmm_control_node_rampup_security_group" },
    var.trainee_tags
  )
}

resource "aws_security_group_rule" "allow-register-access" {
  type              = "ingress"
  description       = "allow access in port 5000 for instance registration"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.control_security_group.id
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
  security_group_id = aws_security_group.control_security_group.id
}

resource "aws_security_group_rule" "allow-all-egress" {
  type              = "egress"
  description       = "allow all egress for each instance"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.control_security_group.id
}

data "aws_vpc" "rampup_vpc" {
  id = var.ramp_up_training_id
}