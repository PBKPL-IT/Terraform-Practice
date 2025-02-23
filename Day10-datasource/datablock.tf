provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "ec2" {
  ami = "ami-0d682f26195e9ec0f"
  instance_type = "t2.micro"
  key_name = "devopskey"
  subnet_id = data.aws_subnet.sub.id
  vpc_security_group_ids = [data.aws_security_groups.sg.ids[0]]
 depends_on = [ aws_s3_bucket.new ]
  
}
resource "aws_s3_bucket" "new" {
  bucket = "pbkpl"
}
 

data "aws_subnet" "sub" {
  filter {
    name = "tag:Name"
    values = ["custom"]
  }
}
data "aws_security_groups" "sg" {
  filter {
    name = "tag:Name"
    values = ["allow_tls"]
  }
}