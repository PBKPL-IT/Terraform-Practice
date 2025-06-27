provider "aws" {
  region = "ap-south-1"
}
# variable "env_name" {}
# variable "instance_type" {}

resource "aws_instance" "name" {
  ami             = "ami-0d682f26195e9ec0f"
  instance_type   = var.instance_type
  key_name        = "devopskey"
  availability_zone = "ap-south-1a"
  
  tags = {
    Name = var.env_name
  }
}
