provider "aws" {
  region = "ap-south-1"
}
provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_subnet_group_name = aws_db_subnet_group.custom.name
  username             = "prsn"
  password             = "prsnlakshmi"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  
  # Backup Configuration
  backup_retention_period = 7                          # Retain backups for 7 days
  backup_window           = "02:00-03:00"              # Backup runs between 2 AM - 3 AM UTC

  # Maintenance Settings
  maintenance_window = "sun:03:00-sun:04:00"           # Weekly maintenance on Sunday 3 AM - 4 AM UTC

  # Multi-AZ Deployment for High Availability
  multi_az = false                                    # Change to true for production deployments

  # Enable Enhanced Monitoring
  monitoring_interval = 60                            # Capture performance metrics every 60s
  monitoring_role_arn = aws_iam_role.rds_monitoring.arn

  # Storage Encryption
  storage_encrypted = true                            # Enable encryption at rest
  kms_key_id        = aws_kms_key.rds.arn             # Use a KMS key for encryption

  # Deletion Protection


  # Enable Performance Insights
  # # Encrypt Performance Insights data
}

# IAM Role for RDS Enhanced Monitoring
resource "aws_iam_role" "rds_monitoring" {
  name = "rds-monitoring-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "monitoring.rds.amazonaws.com" }
    }]
    Version = "2012-10-17"
  })
}

# Attach policy for enhanced monitoring
resource "aws_iam_role_policy_attachment" "rds_monitoring_policy" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# KMS Key for RDS encryption (for storage & performance insights)
resource "aws_kms_key" "rds" {
  description             = "KMS key for encrypting RDS storage and Performance Insights"
  deletion_window_in_days = 7
}

resource "aws_vpc" "dbvpc" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "dbsub1" {
  vpc_id = aws_vpc.dbvpc.id
  availability_zone = "ap-south-1a"
  cidr_block = "10.0.0.0/24"

}
resource "aws_subnet" "dbsub2" {
  vpc_id = aws_vpc.dbvpc.id
  availability_zone = "ap-south-1b"
  cidr_block = "10.0.1.0/24"
}
resource "aws_db_subnet_group" "custom" {
  name       = "newsubgroup"
  subnet_ids = [aws_subnet.dbsub1.id, aws_subnet.dbsub2.id]

  tags = {
    Name = "My DB subnet group"
  }
}
resource "aws_vpc" "nvirginia" {
  provider = aws.us_east
  cidr_block = "10.0.0.0/24"
}
resource "aws_subnet" "nvsub1" {
  vpc_id = aws_vpc.nvirginia.id
  provider = aws.us_east
  availability_zone = "us-east-1a"
  cidr_block = "10.0.0.0/28"

}
resource "aws_subnet" "nvsub2" {
  vpc_id = aws_vpc.nvirginia.id
  provider = aws.us_east
  availability_zone = "us-east-1b"
  cidr_block = "10.0.0.32/28"
}
resource "aws_db_subnet_group" "NVcustom" {
  provider = aws.us_east
  name       = "subgroup"
  subnet_ids = [aws_subnet.nvsub1.id, aws_subnet.nvsub2.id]

  tags = {
    Name = "subnet group"
  }
}
resource "aws_security_group" "replica_sg" {
  provider    = aws.us_east
  name        = "replica_sg"
  description = "Security group for read replica in us-east-1"
  vpc_id      = aws_vpc.nvirginia.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust as necessary
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_kms_key" "default" {
  description = "Encryption key for automated backups"

  provider = aws.us_east
}

resource "aws_db_instance_automated_backups_replication" "default" {
  source_db_instance_arn = aws_db_instance.default.arn
  retention_period       = 14
  kms_key_id = aws_kms_key.default.arn
  provider = aws.us_east
  
 
}
resource "aws_db_instance" "readreplica" {
  provider             = aws.us_east
  identifier           = "mydb-read-replica"         # Unique identifier for the replica
  replicate_source_db  = aws_db_instance.default.arn  # Points to your primary instance
  instance_class       = "db.t3.micro"              # Choose an appropriate instance class
  engine               = aws_db_instance.default.engine
  engine_version       = aws_db_instance.default.engine_version
  storage_encrypted = true
  kms_key_id        = aws_kms_key.default.arn
  # Optionally, you can mirror other settings from your primary:
  publicly_accessible  = false
  storage_type         = "gp2"
  skip_final_snapshot = true

  
  # Ensure the replica is in the same VPC or subnet group if required:
  db_subnet_group_name = aws_db_subnet_group.NVcustom.name
  vpc_security_group_ids = [aws_security_group.replica_sg.id]
  # Additional configuration can be added as needed.

}
output "read_replica_endpoint" {
  value = aws_db_instance.readreplica.endpoint
  
}


