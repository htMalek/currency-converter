provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "almalek_sg_v6" {
  name        = "almalek-sg-v6"
  description = "Allow SSH and Web"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-04b70fa74e45c3917" # Ubuntu 24.04 LTS
  instance_type = "t2.large"
  key_name      = "vockey"
  vpc_security_group_ids = [aws_security_group.almalek_sg_v6.id]

  tags = {
    Name = "Almalek-Converter-Instance"
  }
}

output "instance_ip" {
  value = aws_instance.app_server.public_ip
}
