resource "aws_instance" "name" {
  ami = "ami-0ddfba243cbee3768"
  instance_type = "t2.micro"
  key_name = "devopskey"
  
  
}
resource "aws_ec2_instance_state" "example" {
  instance_id    = "i-043267372c33d5593"
  state         = "running"
}
