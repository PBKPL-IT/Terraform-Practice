resource "aws_iam_role" "ec2_s3_role" {
  name = "EC2S3AccessRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# IAM Policy for S3 access
resource "aws_iam_policy" "s3_access_policy" {
  name        = "S3AccessPolicy"
  description = "Allows EC2 instances to access S3"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::your-bucket-name",
        "arn:aws:s3:::your-bucket-name/*"
      ]
    }
  ]
}
EOF
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2S3InstanceProfile"
  role = aws_iam_role.ec2_s3_role.name
}
resource "aws_key_pair" "key" {
  key_name = "awsdevopskey"
public_key = file("~/.ssh/id_rsa.pub")
}
 resource "aws_instance"  "web_server" {
   ami = "ami-0d682f26195e9ec0f"
   instance_type = "t2.micro"
   key_name = aws_key_pair.key.key_name
   security_groups = ["default"]
   iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
   availability_zone = "ap-south-1a"
   tags = {
     Name = "webserver"
   }
 }
 resource "aws_s3_bucket" "bkt" {
   bucket="prsnlakshmi"
 }
  
resource "null_resource" "setupandupload" {
  depends_on = [ aws_instance.web_server ]
  provisioner "remote-exec" {
    inline = [ "sudo yum install httpd",
    "sudo systemctl start httpd",
    "sudo systemctl enable httpd",

      # Ensure /var/www/html/ directory exists
      "sudo mkdir -p /var/www/html/",

      # Create a sample index.html file
      "echo '<h1>Welcome to My Web Server</h1>' | sudo tee /var/www/html/index.html",

      # Upload the file to S3
      "aws s3 cp /var/www/html/index.html s3://prsnlakshmi/",
      "echo 'File uploaded to S3'"
    ]
  } 
    connection {
    type = "ssh"
    user= "ec2-user"
    private_key=file("~/.ssh/id_rsa")
    host = aws_instance.web_server.public_ip
  } 
  triggers = {
    Instance_id=aws_instance.web_server.id
  }
}
   
