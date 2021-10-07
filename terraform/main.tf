terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = var.RampUpRegion
}

resource "aws_instance" "frontend_server" {
  ami           = var.UbuntuAMI
  instance_type = var.InstanceType
  availability_zone = var.AvailabilityZone
  subnet_id = var.rampup_training_public_id
  vpc_security_group_ids = [ aws_security_group.rampup_security_group.id ]
  tags = {
    Name = "frontend-rampup-cristian.mejiam"
    project     = "ramp-up-devops"
    responsible = var.IAMUser
  }
  volume_tags = {
    name = "frontVol-rampup-cristian.mejiam"
    project     = "ramp-up-devops"
    responsible = var.IAMUser
  }
}

resource "aws_security_group" "rampup_security_group" {
  vpc_id = var.ramp_up_training_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  tags = {
    project     = "ramp-up-devops"
    responsible = var.IAMUser
  }
}