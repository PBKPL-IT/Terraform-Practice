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
  availability_zone = "us-east-1a"
  cidr_block = "10.0.0.0/24"

}
resource "aws_subnet" "dbsub2" {
  vpc_id = aws_vpc.dbvpc.id
  availability_zone = "us-east-1b"
  cidr_block = "10.0.1.0/24"
}
resource "aws_db_subnet_group" "custom" {
  name       = "newsubgroup"
  subnet_ids = [aws_subnet.dbsub1.id, aws_subnet.dbsub2.id]

  tags = {
    Name = "My DB subnet group"
  }
}