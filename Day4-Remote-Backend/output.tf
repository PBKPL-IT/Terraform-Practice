output "type" {
  value = aws_instance.name.instance_type
}
output "pub-ip" {
 
 value = aws_instance.name.public_ip
 
}
output "Name" {
  value = aws_instance.name.tags
}
output "privateip" {
  value = aws_instance.name.private_ip
}