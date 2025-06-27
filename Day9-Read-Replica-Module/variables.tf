variable "db_identifier" {
  description = "Primary DB identifier for read replica"
  type        = string
}
variable "major_engine_version" {
  description = "The major engine version of the RDS instance"
  type        = string
  default = "5.7"
}
variable "aws_region" {
  description = "providing region  to the ReadReplica"
  type=string
  default = "us-east-1"
}