provider "aws" {
  alias  = "ap_south_1"
  region = "ap-south-1"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

module "s3_bucket_ap_south_1" {
  source  = "terraform-aws-modules/s3-bucket/aws"

  bucket = "pbkpl-ap-south-1"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  providers = {
    aws = aws.ap_south_1
  }
  versioning ={
       enabled = true
   }
}

module "s3_bucket_us_east_1" {
  source  = "terraform-aws-modules/s3-bucket/aws"

  bucket = "pbkpl-us-east-1"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  providers = {
    aws = aws.us_east_1
  }
   
}
