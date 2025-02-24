provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "key" {
  key_name = "awsdevopskey"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "name" {
  ami="ami-0261755bbcb8c4a84"
  instance_type = "t2.micro"
  key_name = aws_key_pair.key.key_name

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host = self.public_ip
  }

  provisioner "local-exec" {
    command = "touch file45"
  }

  provisioner "file" {
    source = "file110"
    destination = "/home/ubuntu/file10"
  }
  provisioner "remote-exec" {
    inline = [ "touch file25", 
      "echo hello from AWS >> file25",
      ]
  }
}
