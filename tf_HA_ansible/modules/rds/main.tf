resource "aws_db_instance" "database" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.${var.InstanceType}"
  name                   = var.instance_name
  identifier             = var.instance_name
  port                   = var.port
  username               = var.db_user
  password               = var.db_pass
  skip_final_snapshot    = true
  availability_zone      = var.AvailabilityZone
  db_subnet_group_name   = "default-${var.ramp_up_training_id}"
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
  publicly_accessible = true
}

resource "aws_security_group" "db_security_group" {
  vpc_id = var.ramp_up_training_id
  tags = merge(
    { name = "db_rampup_security_group" },
    var.trainee_tags
  )
}

# This data block is for obtaining the host's IP address
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group_rule" "allow-db-access" {
  type              = "ingress"
  description       = "allow access in port 3306 from host ip"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = [
                        "${chomp(data.http.myip.body)}/32",
                        data.aws_vpc.rampup_vpc.cidr_block
                      ] # chomp function is to erase newline characters at the end of the string
  security_group_id = aws_security_group.db_security_group.id
}

resource "aws_security_group_rule" "allow-all-egress" {
  type              = "egress"
  description       = "allow all egress for each instance"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db_security_group.id
}

data "aws_vpc" "rampup_vpc" {
  id = var.ramp_up_training_id
}