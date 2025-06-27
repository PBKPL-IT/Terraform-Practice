
module "dev_instance" {
  source        = "../Day14/module/ec2-instance"
  env_name      = "dev"
  instance_type = "t2.micro"
}
