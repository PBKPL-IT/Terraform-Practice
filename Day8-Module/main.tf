module "name" {
 source = "../Day8-sourcecode"
ami_id = "ami-0ddfba243cbee3768"
type = "t2.micro"
key = "devopskey"
availability_zone = "ap-south-1a"
aws_s3_bucket = "pbkpl"

}