resource "aws_instance" "frontend_server" {
  ami                    = var.UbuntuAMI
  instance_type          = var.InstanceType
  availability_zone      = var.AvailabilityZone
  subnet_id              = var.rampup_subnet_id
  key_name               = var.key_pair_name
  
  vpc_security_group_ids = [aws_security_group.instance_security_group.id]
  user_data = data.local_file.instance_provisioner.content

  tags = merge(
    {Name        = var.instance_name},
    var.trainee_tags
  )
  volume_tags = merge(
    {Name        = var.volume_name},
    var.trainee_tags
  )
}

data "local_file" "instance_provisioner" {
  filename = "C:/Users/cristian.mejiam/Desktop/DevOpsRampUp/terraform/scripts/${var.provisioner_file}"
}

resource "aws_security_group" "instance_security_group" {
  vpc_id = var.ramp_up_training_id
  tags = merge(
    { Name = "${var.module}_rampup_security_group" },
    var.trainee_tags
  )
}

resource "aws_security_group_rule" "allow-http-access" {
  type              = "ingress"
  description       = "allow access in each instance selected port, 3030 for front, 3000 for back and 3306 for DB"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.instance_security_group.id
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
  cidr_blocks       = ["${chomp(data.http.myip.body)}/32"] # chomp function is to erase newline characters at the end of the string
  security_group_id = aws_security_group.instance_security_group.id
}

resource "aws_security_group_rule" "allow-all-egress" {
  type = "egress"
  description = "allow all egress for each instance"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.instance_security_group.id
}