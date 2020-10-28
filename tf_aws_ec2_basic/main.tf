terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.12.0"
    }
  }
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

resource "aws_instance" "sbe-ubuntu2004-test" {
  ami           = var.aws_ami_ubuntu2004
  instance_type = "t2.micro"
  tags = {
    Name = "sbe-ubuntu2004-test"
  }
}