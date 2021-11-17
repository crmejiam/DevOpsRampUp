variable "RampUpRegion" {
  description = "Region in which we are going to develop all activities of the Ramp Up"
  type        = string
  default     = "us-west-1"
}

variable "s3_bucket_name" {
  description = "Name of the Ramp Up s3 Bucket"
  type        = string
  default     = "ramp-up-devops-psl"
}

variable "tfstate_file_path" {
  description = "Path in which terraform.tfstate is going to be uploaded on s3 bucket"
  type        = string
  default     = "cristian.mejiam/terraform.tfstate"
}

variable "AvailabilityZone" {
  description = "Availability Zone for the public and private subnet that we are going to use"
  type        = string
  default     = "us-west-1a"
}

variable "ramp_up_training_id" {
  description = "ID for the vpc of the rampup"
  type        = string
  default     = "vpc-0d2831659ef89870c"
}

variable "rampup_subnet_id" {
  description = "ID of the subnets for each instance, 0 is public, 1 is private"
  type        = list(string)
  default     = ["subnet-0088df5de3a4fe490", "subnet-0d74b59773148d704"]
}

variable "rampup_subnet_id_2" {
  description = "ID of the subnets for each instance, 0 is public, 1 is private"
  type        = list(string)
  default     = ["subnet-055c41fce697f9cca", "subnet-038fa9d9a69d6561e"]
}

variable "trainee_tags" {
  description = "Tags that are necessary to every resource in order to be created"
  type        = map(string)
  default = {
    project     = "ramp-up-devops"
    responsible = "cristian.mejiam"
  }
}

variable "server_type" {
  description = "List with the name of the modules"
  type        = list(string)
  default     = ["frontend", "backend"]
}

variable "InstanceType" {
  description = "The type of instance that we are going to use in the Ramp Up"
  type        = string
  default     = "t2.micro"
}

variable "provisioner_file" {
  description = "List with the names of each provisioner .tpl file (which is a .sh with terraform variables on it)"
  type        = list(string)
  default     = ["Provision-frontend.tpl", "Provision-backend.tpl", "Provision-control-node.tpl"]
}

variable "port" {
  description = "List of ports designed for access in each instance"
  type        = list(number)
  default     = [3030, 3000, 3306, 5000]
}

variable "ssh_port" {
  description = "port for ssh access"
  type        = number
  default     = 22
}

variable "launch_template_name" {
  description = "List with the names of the launch templates for each tier"
  type        = list(string)
  default     = ["cmm-front-rampup-launch-template", "cmm-back-rampup-launch-template"]
}

variable "load_balancer_name" {
  description = "List with the names of the launch templates for each tier"
  type        = list(string)
  default     = ["cmm-front-load-balancer", "cmm-back-load-balancer"]
}

variable "internal_facing_lb_value" {
  description = "Boolean variable that says if a load balancer is internal facing or not"
  type        = list(bool)
  default     = [false, true]
}

variable "node_type" {
  description = "Type of ansible node, can be [control, managed]"
  type = list(string)
  default = [managed, managed, control]
}