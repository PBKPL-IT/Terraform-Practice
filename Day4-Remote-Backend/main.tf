resource "aws_instance" "name" {
  ami = "ami-0ddfba243cbee3768"
  instance_type = "t2.micro"
  key_name = "devopskey"
  tags = {
    Name = "Dev"
  }
  
}
terraform {
  backend "s3" {
    bucket = "pbkpl"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}
