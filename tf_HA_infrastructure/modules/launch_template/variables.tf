variable server_type {}

variable "UbuntuAMI" {
  description = "Ubuntu AMI for the RampUpRegion"
  type        = string
  default     = "ami-0d382e80be7ffdae5"
}

variable "InstanceType" {}

variable "key_pair_name" {
  description = "The EC2 Key Pair to associate with the EC2 Instance for SSH access."
  type        = string
  default     = "Ramp-Up-cristian.mejiam-Key-Pair"
}

variable trainee_tags {}

variable "provisioner_file" {}

variable "env_variables" {}

variable "ramp_up_training_id" {}

variable port {}

variable ssh_port {}

variable rds_endpoint {}