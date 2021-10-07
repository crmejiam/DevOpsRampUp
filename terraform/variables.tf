variable "RampUpRegion" {
    description = "Region in which we are going to develop all activities of the Ramp Up"
    type = string
    default = "us-west-1"
}

variable "UbuntuAMI" {
    description = "Ubuntu AMI for the RampUpRegion"
    type = string
    default = "ami-0d382e80be7ffdae5"
}

variable "AvailabilityZone" {
    description = "Availability Zone for the public and private subnet that we are going to use"
    type = string
    default = "us-west-1a"
}

variable "InstanceType" {
    description = "The type of instance that we are going to use in the Ramp Up"
    type = string
    default = "t2.micro"
}

variable "IAMUser" {
    description = "IAM User for the responsible of the created resources"
    type = string
    default = "cristian.mejiam"
}

variable "ramp_up_training_id" {
    description = "ID for the vpc of the rampup"
    type = string
    default = "vpc-0d2831659ef89870c"
}

variable "rampup_training_private_id" {
    description = "ID for the private subnet #0 of the rampup"
    type = string
    default = "subnet-0d74b59773148d704"
}

variable "rampup_training_public_id" {
    description = "ID for the public subnet #0 of the rampup"
    type = string
    default = "subnet-0088df5de3a4fe490"
}