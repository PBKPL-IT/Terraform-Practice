resource "aws_instance" "name" {
  ami = "ami-0ddfba243cbee3768"
  instance_type = "t2.micro"
  key_name = "devopskey"
  subnet_id = aws_subnet.pubsub.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  
  tags = {
    Name = "EC2"
  }
}
resource "aws_instance" "privateserver" {
   ami = "ami-0ddfba243cbee3768"
  instance_type = "t2.micro"
  key_name = "devopskey"
  subnet_id = aws_subnet.privatesub.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
}