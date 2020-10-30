# Basic EC2 instance creation

# Assign Elastic IP
# Configure with existing keypair
# Attach existing Security Group
#


terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.12"
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
  key_name = var.key              # leverages existing key.pem 
  security_groups = [var.aws_sg]  # assumes the specified group is already defined in AWS
  tags = {
    Name = "sbe-ubuntu2004-test"
    Owner = "sbenfredj"
  }
}

resource "aws_eip" "sbe-ubuntu2004-test" {
  instance = aws_instance.sbe-ubuntu2004-test.id
}