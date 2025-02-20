resource "aws_instance" "name" {
  ami = "ami-0ddfba243cbee3768"
  instance_type = "t2.micro"
  key_name = "devopskey"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "life-cycle"
  }
  lifecycle {
    create_before_destroy = true
  }
}