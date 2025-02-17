resource "aws_instance" "name" {
  ami = var.ami_id
  instance_type = var.type
  key_name = var.key
  availability_zone = var.availability_zone
  
}
resource "aws_s3_bucket" "name" {
  bucket = var.aws_s3_bucket
}