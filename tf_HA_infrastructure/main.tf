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
}