variable "RampUpRegion" {
  description = "Region in which we are going to develop all activities of the Ramp Up"
  type        = string
  default     = "us-west-1"
}

variable "s3_bucket_name" {
    description = "Name of the Ramp Up s3 Bucket"
    type = string
    default = "ramp-up-devops-psl"
}

variable "tfstate_file_path" {
    description = "Path in which terraform.tfstate is going to be uploaded on s3 bucket"
    type = string
    default = "cristian.mejiam/terraform.tfstate"
}