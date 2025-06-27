provider "aws" {
  
}
resource "aws_instance" "example" {
  for_each      = toset([for i in range(1, 51) : "server-${i}"])
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  tags = {
    Name = each.key
  }
}
