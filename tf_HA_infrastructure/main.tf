terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  backend "s3" {
    bucket = "ramp-up-devops-psl"
    key    = "cristian.mejiam/terraform.tfstate"
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

  count = length(var.server_type)

  server_type         = var.server_type[count.index]
  InstanceType        = var.InstanceType
  trainee_tags        = var.trainee_tags
  ramp_up_training_id = var.ramp_up_training_id
  port                = var.port[count.index]
  ssh_port            = var.ssh_port
  provisioner_file    = var.provisioner_file[count.index]
  rds_endpoint        = module.rds_instance.rds_endpoint
  env_variables       = local.env_variables[count.index]
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

module "autoscaling_group" {
  depends_on = [module.launch_template, module.load_balancer]
  source     = "./modules/autoscaling_group"
  count      = length(var.server_type)

  server_type           = var.server_type[count.index]
  subnet_id             = var.rampup_subnet_id[count.index]
  tier_target_group_arn = module.target_group[count.index].tier_target_group_arn
  launch_template_id    = module.launch_template[count.index].launch_template_id
}

module "rds_instance" {
  source = "./modules/rds"

  InstanceType        = var.InstanceType
  AvailabilityZone    = var.AvailabilityZone
  rampup_subnet_id    = var.rampup_subnet_id[1]
  trainee_tags        = var.trainee_tags
  ramp_up_training_id = var.ramp_up_training_id
  port                = var.port[2]
}

locals {
  env_variables = [{
    back_host = module.load_balancer[1].tier_load_balancer_address
    },
    {
      db_user      = # Here goes db admin user
      db_pass      = # Here goes db admin pass
    }
  ]
}