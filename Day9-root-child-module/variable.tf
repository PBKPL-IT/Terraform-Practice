variable "amiId" {
  type = string
  default = "ami-0d682f26195e9ec0f"

}
variable "type" {
  type = string
  default = "t2.micro"

}
variable "tags" {
  type = string
  default = "Newec2"
}
variable "bucket_name" {
  default = "pbkpl"
}