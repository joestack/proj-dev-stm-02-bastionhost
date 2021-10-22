variable "aws_region" {
    ### FIX_ME: connect to foundation
  description = "AWS region"
  default     = "eu-west-1"
}

variable "name" {
  description = "Unique name of the deployment"
  default     = "stm-dev"
}

variable "instance_type" {
  description = "instance size to be used for worker nodes"
  default     = "t2.small"
}

variable "pub_key" {
  description = "the public key to be used to access the bastion host and ansible nodes"
  default     = "joestack"
}

variable "pri_key" {
  description = "the base64 encoded private key to be used to access the bastion host and ansible nodes"
}


locals {
  priv_key = base64decode(var.pri_key)
}