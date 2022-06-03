resource "aws_iam_role" "ec2_role_Assessment" {
  name = "ec2_role_Assessment"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "ec2_profile_Assessment" {
  name = "ec2_profile_Assessment"
  role = aws_iam_role.ec2_role_Assessment.name
}

resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2_policy"
  role = aws_iam_role.ec2_role_Assessment.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer",
		"eks:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}



data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_security_group" "dockerinstance" {
  name        = "dockerinstance"
  vpc_id      = module.vpc_assess.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 2375
    to_port   = 2375
    protocol  = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 

}

/*
resource "tls_private_key" "dockerinstancesshkey" {
  algorithm   = "RSA"
  rsa_bits = "2048"  
}


resource "local_file" "dockerinstancesshkey" { 
  filename = "${path.root}/dockerinstancesshkey.pem"
  content = tls_private_key.dockerinstancesshkey.private_key_pem
  file_permission = 600
  depends_on = [
    tls_private_key.dockerinstancesshkey
  ]
}

data "local_file" "dockerinstancesshkey" {
    filename = "${path.root}/dockerinstancesshkey.pem"
	 depends_on = [
        local_file.dockerinstancesshkey
  ]
}


resource "aws_key_pair" "dockerinstancesshkey" {
  public_key = tls_private_key.dockerinstancesshkey.public_key_openssh
}

*/

resource "aws_instance" "dockerinstance" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"

  root_block_device {
    volume_size = 8
  }

  vpc_security_group_ids = [ aws_security_group.dockerinstance.id  ]
  subnet_id = module.vpc_assess.public_subnets[0]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile_Assessment.name
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    set -ex
    sudo yum update -y
    sudo amazon-linux-extras install docker -y
    sudo service docker start
    sudo usermod -a -G docker ec2-user
  EOF

  key_name                = aws_key_pair.dockerinstancesshkey.key_name
  monitoring              = true
  disable_api_termination = false
  ebs_optimized           = true
}