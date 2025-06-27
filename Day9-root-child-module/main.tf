module "name-ec2" {
  source = "./module/ec2"
  ami_id = var.amiId
  instance_type = var.type
  newtag = var.tags
}

 module "s3_bucket" {
  source      = "./module/s3"
  bucket_name = var.bucket_name
 }