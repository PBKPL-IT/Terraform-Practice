module "read_replica" {
  source  = "terraform-aws-modules/rds/aws"


  

  identifier          = "read-replica"
  replicate_source_db = var.db_identifier  # Get from the primary module
  engine = "mysql"
  major_engine_version = var.major_engine_version
  instance_class = "db.t3.micro"
  publicly_accessible = false
  skip_final_snapshot = true
  family = "mysql5.7"
  create_db_subnet_group = true
  subnet_ids = ["subnet-00a2ee0cd2c786ecc", "subnet-0ca2f232284c05728"]
  

}
