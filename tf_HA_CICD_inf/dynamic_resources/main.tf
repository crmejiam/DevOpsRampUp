terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  backend "s3" {
    bucket = "ramp-up-devops-psl"
    key    = "cristian.mejiam/terraform.dynamic-tfstate"
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

module "autoscaling_group" {
  source = "./modules/autoscaling_group"
  count  = length(var.server_type)

  server_type  = var.server_type[count.index]
  subnet_id    = var.rampup_subnet_id[count.index]
  trainee_tags = var.trainee_tags
}
