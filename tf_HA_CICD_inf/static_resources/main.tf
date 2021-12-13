terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  backend "s3" {
    bucket = "ramp-up-devops-psl"
    key    = "cristian.mejiam/terraform.static-tfstate"
    region = "us-west-1"
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = var.RampUpRegion
  default_tags {
    tags = var.trainee_tags
  }
}

module "launch_template" {
  source = "./modules/launch_template"

  count               = length(var.server_type)
  UbuntuAMI           = var.UbuntuAMI
  key_pair_name       = var.key_pair_name
  server_type         = var.server_type[count.index]
  InstanceType        = var.InstanceType
  trainee_tags        = var.trainee_tags
  ramp_up_training_id = var.ramp_up_training_id
  port                = var.port[count.index]
  ssh_port            = var.ssh_port
  provisioner_file    = var.provisioner_file[0]
  control_node_ip     = module.control_node.private_ip
  control_node_port   = var.port[3]
}

module "load_balancer" {
  source = "./modules/load_balancer"

  count = length(var.server_type)

  server_type              = var.server_type[count.index]
  internal_facing_lb_value = var.internal_facing_lb_value[count.index]
  rampup_subnet_id         = var.rampup_subnet_id[count.index]
  rampup_subnet_id_2       = var.rampup_subnet_id_2[count.index]
  port                     = var.port[count.index]
  ramp_up_training_id      = var.ramp_up_training_id
  ssh_port                 = var.ssh_port
  trainee_tags             = var.trainee_tags
}

module "target_group" {
  source = "./modules/target_group"
  count  = length(var.server_type)

  server_type                   = var.server_type[count.index]
  port                          = var.port[count.index]
  ramp_up_training_id           = var.ramp_up_training_id
  application_load_balancer_arn = module.load_balancer[count.index].tier_load_balancer_arn
}

module "rds_instance" {
  source = "./modules/rds"

  InstanceType        = var.InstanceType
  AvailabilityZone    = var.AvailabilityZone
  rampup_subnet_id    = var.rampup_subnet_id[1]
  trainee_tags        = var.trainee_tags
  ramp_up_training_id = var.ramp_up_training_id
  port                = var.port[2]
  db_user = data.aws_ssm_parameter.db_user.value
  db_pass = data.aws_ssm_parameter.db_pass.value
}

module "control_node" {
  depends_on = [module.rds_instance]

  source = "./modules/control_node"

  UbuntuAMI        = var.UbuntuAMI
  InstanceType     = var.InstanceType
  AvailabilityZone = var.AvailabilityZone
  rampup_subnet_id = var.rampup_subnet_id[0]
  key_pair_name    = var.key_pair_name
  trainee_tags     = var.trainee_tags
  provisioner_file = var.provisioner_file[1]
  env_variables = merge(
    { db_user = data.aws_ssm_parameter.db_user.value
    db_pass = data.aws_ssm_parameter.db_pass.value 
    aws_access_key_id = data.aws_ssm_parameter.aws_access_key_id.value
    aws_secret_access_key = data.aws_ssm_parameter.aws_secret_access_key.value},
    local.env_variables[0]
  )
  ramp_up_training_id = var.ramp_up_training_id
  port                = var.port[3]
  ssh_port            = var.ssh_port
}

locals {
  env_variables = [{
    back_host    = module.load_balancer[1].tier_load_balancer_address
    rds_endpoint = module.rds_instance.rds_endpoint
  }]
}

data "aws_ssm_parameter" "db_user" {
  name = "cmm-rampup-dbuser"
}

data "aws_ssm_parameter" "db_pass" {
  name = "cmm-rampup-dbpass"
}

data "aws_ssm_parameter" "aws_access_key_id" {
  name = "amazon_access_key_id"
}

data "aws_ssm_parameter" "aws_secret_access_key" {
  name = "amazon_secret_access_key"
}