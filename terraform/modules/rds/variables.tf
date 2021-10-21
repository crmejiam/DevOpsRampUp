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

variable "InstanceType" {}

variable "AvailabilityZone" {}

variable "rampup_subnet_id" {}

variable "instance_name" {}

variable "trainee_tags" {}

variable "ramp_up_training_id" {}

variable "port" {}

variable "db_user" {
  description = "admin user of the database"
  type        = string
  default     = "dbrampup"
}
variable "db_pass" {
  description = "password of the database"
  type        = string
  default     = "ubuntudb"
}

variable "backendIP" {}