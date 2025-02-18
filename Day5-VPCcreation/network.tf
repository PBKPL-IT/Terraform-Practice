resource "aws_vpc" "test" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Custom_vpc"
  }
}
resource "aws_internet_gateway" "IG"{
  vpc_id = aws_vpc.test.id
}
resource "aws_subnet" "pubsub" {
  vpc_id = aws_vpc.test.id
  cidr_block = "10.0.0.0/28"
  map_public_ip_on_launch = true
   tags = {
     Name = "Pubsub"
   }
}
resource "aws_subnet" "privatesub" {
  vpc_id = aws_vpc.test.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "privatesub"
  }
}
resource "aws_route_table" "PubRT" {
  vpc_id = aws_vpc.test.id
  route {
    gateway_id = aws_internet_gateway.IG.id
    cidr_block = "0.0.0.0/0"
  }
}
resource "aws_route_table" "privateRT" {
  vpc_id = aws_vpc.test.id
  route {
    gateway_id = aws_nat_gateway.nat.id
    cidr_block = "0.0.0.0/0"
  }
}
resource "aws_route_table_association" "pubasso" {
  route_table_id = aws_route_table.PubRT.id
  subnet_id = aws_subnet.pubsub.id
}
resource "aws_route_table_association" "privateasso" {
  route_table_id = aws_route_table.privateRT.id
  subnet_id = aws_subnet.privatesub.id
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "allow ssh"
  vpc_id      = aws_vpc.test.id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks =["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
resource "aws_eip" "name" {
  domain = "vpc"

}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.name.id
  subnet_id = aws_subnet.pubsub.id
}