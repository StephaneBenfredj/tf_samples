variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {
     default = "eu-west-1"
}

variable "aws_ami_ubuntu2004" {
     default = "ami-06fd8a495a537da8b"
}

variable "key" {
     description = "Existing keypair to use"
}
variable "aws_sg" {
     description = "Existing Security Group to use"
}
