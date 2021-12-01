variable "InstanceType" {}

variable "AvailabilityZone" {}

variable "rampup_subnet_id" {}

variable "instance_name" {
    description = "name of the rds instance"
    type = string
    default = "cmmdbrampup"
}

variable "trainee_tags" {}

variable "ramp_up_training_id" {}

variable "port" {}

variable "db_user" {}
variable "db_pass" {}