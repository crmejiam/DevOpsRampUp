# Example on how to use root variables on modules
# on root module 
# ---------------------------------------------------------------
# variable "vcenter_user" {}
# module "vsphere" {
#     source "./module/vsphere"
#     username = var.vcenter_user
# }
# -----------------------------------------------------------------
# on child module 
# -----------------------------------------------------------------
# variable "username" {}
# resource "local_file" "vcsa_template" {
#     content ....
#     admin_username = var.username
# }
# -----------------------------------------------------------------

variable "UbuntuAMI" {}

variable "InstanceType" {}

variable "AvailabilityZone" {}

variable "rampup_subnet_id" {}

variable "key_pair_name" {}

variable "instance_name" {}

variable "volume_name" {}

variable "trainee_tags" {}

variable "provisioner_file" {}

variable "ramp_up_training_id" {}

variable "server_type" {}

variable "port" {}

variable "ssh_port" {
  description = "The EC2 port that terraform is going to use to ssh on the machine"
  type        = number
  default = 22
}

variable "privateIP" {}

variable "env_variables" {}