resource "aws_instance" "name" {
  ami = "ami-0ddfba243cbee3768"
  instance_type = "t2.micro"
  key_name = "devopskey"
  subnet_id = aws_subnet.sub.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  tags = {
    Name = "EC2"
  }
}