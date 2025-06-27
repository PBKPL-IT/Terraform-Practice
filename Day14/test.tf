module "test_instance" {
  source        = "../Day14/module/ec2-instance"
  env_name      = "test"
  instance_type = "t3.micro"
}
