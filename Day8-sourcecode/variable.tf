variable "ami_id" {
  description = "instance AMI"
  type = string
  default = ""
  }

variable "type" {
   type = string
   default = ""

 }
variable "key" {
    type = string
    default = ""

  }  
  variable "availability_zone" {
    type = string
    default = "" 
  }
  variable "aws_s3_bucket" {
    type = string
    default = ""
  }