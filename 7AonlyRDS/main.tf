provider "aws" {
  
}
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "var.engine"
  engine_version       = "8.0"
  instance_class       = "var.class"
  username             = "var.uname"
  password             = "var.pwd"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}
