# Variable name declaration between modules:
# If a variable is going to be used globally for all modules then is going to have the same name on all
# declarations, for example:

# On root variables.tf --> variable userID{}, module... userID = var.userID
# on module variables.tf --> variable userID{}, user_id = var.userID

# If a variable is going to be used from one module to another (except root module) then is going to have
# a prefix of the origin module on the name, for example:

# on backend module variables.tf --> variable staticIP{}, ip = var.staticIP{}
# on frontend module variables.tf --> variable backend_IP{}, API = var.backend_IP

variable "RampUpRegion" {
  description = "Region in which we are going to develop all activities of the Ramp Up"
  type        = string
  default     = "us-west-1"
}

variable "UbuntuAMI" {
  description = "Ubuntu AMI for the RampUpRegion"
  type        = string
  default     = "ami-0d382e80be7ffdae5"
}

variable "AvailabilityZone" {
  description = "Availability Zone for the public and private subnet that we are going to use"
  type        = string
  default     = "us-west-1a"
}

variable "InstanceType" {
  description = "The type of instance that we are going to use in the Ramp Up"
  type        = string
  default     = "t2.micro"
}

variable "ramp_up_training_id" {
  description = "ID for the vpc of the rampup"
  type        = string
  default     = "vpc-0d2831659ef89870c"
}

# variable "rampup_subnet_id" {
#   description = "ID of the subnets for each instance, 0 is public, 1 and 2 are private"
#   type        = list(string)
#   default     = ["subnet-0088df5de3a4fe490", "subnet-0d74b59773148d704", "subnet-0d74b59773148d704"]
#   # index 1 and 2 are repeated in order to match count value
# }

# TEMPORARY DEBUG VALUE
# all subnet ids are the public subnet id, all for ssh access and debug purposes
variable "rampup_subnet_id" {
  description = "ID of the subnets for each instance, 0 is public, 1 and 2 are private"
  type        = list(string)
  default     = ["subnet-0088df5de3a4fe490", "subnet-0088df5de3a4fe490", "subnet-0088df5de3a4fe490"]
}

variable "key_pair_name" {
  description = "The EC2 Key Pair to associate with the EC2 Instance for SSH access."
  type        = string
  default     = "Ramp-Up-cristian.mejiam-Key-Pair"
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
  default     = ["frontend", "backend", "database"]
}

variable "instance_name" {
  description = "List with the names of each instance"
  type        = list(string)
  default     = ["frontend-rampup-cristian.mejiam", "backend-rampup-cristian.mejiam", "database-rampup-cristian.mejiam"]
}

variable "volume_name" {
  description = "List with the names of each volume"
  type        = list(string)
  default     = ["frontVol-rampup-cristian.mejiam", "backVol-rampup-cristian.mejiam", "dbVol-rampup-cristian.mejiam"]
}

variable "provisioner_file" {
  description = "List with the names of each provisioner .tpl file (which is a .sh with terraform variables on it)"
  type        = list(string)
  default     = ["Provision-frontend.tpl", "Provision-backend.tpl", "Provision-database.tpl"]
}

variable "port" {
  description = "List of ports designed for access in each instance"
  type        = list(number)
  default     = [3030, 3000, 3306]
}

variable "privateIP" {
  description = "List of predefined private ips"
  type        = list(string)
  # IP addresses in their normal distribution between the subnets
  # default = ["10.1.0.10", "10.1.80.8", "10.1.80.12"]  # 10.1.0.10 for front, 10.1.80.0 for back, 10.1.80.12 for db

  # TEMPORARY DEBUG VALUE
  # IP addresses on public subnets in order to test if they work 
  default = ["10.1.0.10", "10.1.0.8", "10.1.0.12"]
}

# vars with their normal ip distribution
# variable "tpl_vars" {
#   description = "List of variables passed to instances with tpl_file"
#   type = list(map(string))
#   default = [ {
#     back_host = "10.1.80.8" 
#   },
#   {
#     db_host = "10.1.80.12"
#     db_user = "root"
#     db_pass = "ubuntu"
#   },
#   {
#     back_host = "10.1.80.8"
#   }
#   ]
# }

# TEMPORARY DEBUG VALUE
variable "env_variables" {
  description = "List of environment variables passed with template_file block"
  type        = list(map(string))
  default = [{
    back_host = "10.1.0.8"
    },
    {
      db_host = "10.1.0.12"
      db_user = "backrampup"
      db_pass = "ubuntu"
    },
    {
      back_host = "10.1.0.8"
    }
  ]
}