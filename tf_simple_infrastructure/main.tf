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

module "ec2_instance" {

  depends_on = [module.rds_instance]

  count               = length(var.server_type)
  server_type         = var.server_type[count.index]
  source              = "./modules/ec2"
  UbuntuAMI           = var.UbuntuAMI
  InstanceType        = var.InstanceType
  AvailabilityZone    = var.AvailabilityZone
  rampup_subnet_id    = var.rampup_subnet_id[count.index]
  key_pair_name       = var.key_pair_name
  trainee_tags        = var.trainee_tags
  ramp_up_training_id = var.ramp_up_training_id
  instance_name       = var.instance_name[count.index]
  volume_name         = var.volume_name[count.index]
  provisioner_file    = var.provisioner_file[count.index]
  port                = var.port[count.index]
  ssh_port            = var.ssh_port
  privateIP           = var.privateIP[count.index]
  env_variables       = var.env_variables[count.index]
  rds_endpoint         = module.rds_instance.rds_endpoint
}

module "rds_instance" {
  source              = "./modules/rds"
  InstanceType        = var.InstanceType
  AvailabilityZone    = var.AvailabilityZone
  rampup_subnet_id    = var.rampup_subnet_id[2]
  trainee_tags        = var.trainee_tags
  ramp_up_training_id = var.ramp_up_training_id
  instance_name       = var.instance_name[2]
  port                = var.port[2]
  backendIP = var.privateIP[1]
}
