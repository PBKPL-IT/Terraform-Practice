#module "prasu" {
  #  identifier = "demodb"
  #source = "git::https://github.com/terraform-aws-modules/terraform-aws-rds.git"
  #db_subnet_group_tags = {Name="dbsubnet"}
  #create_db_subnet_group = true
  #db_subnet_group_name = "my-subnet-group"
  #subnet_ids = ["subnet-0c1755b52e3110849", "subnet-03184c417ebbfaf4b"]
 # family = "mysql"
#}
module "db_parameter_group" {
  source  = "terraform-aws-modules/rds/aws//modules/db_parameter_group"
  # version = "5.0.0"

  name   = "my-db-parameter-group"
  family = "postgres13"  # Set correct DB family based on your engine
}
