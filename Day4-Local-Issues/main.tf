resource "aws_instance" "name" {
  ami = "ami-0ddfba243cbee3768"
  instance_type = "t2.micro"
  key_name = "devopskey"
  tags = {
    Name = "Dev"
  }
  
}
resource "aws_s3_bucket" "pbkpl" {
    bucket = "pbkpl"
  
}
#

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.pbkpl.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.version.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}




#note Developers Overwriting Each Other’s Work if separe state file for same project
#Merge Conflicts in terraform.tfstate
#If two developers run terraform apply at the same time, one may overwrite the other's changes, causing unexpected resource modifications.
#both developers working independetly not collabrati ve 
#solution: maintain common ststefile to overocme above issues 