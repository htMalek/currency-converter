provider "aws" {
  region = "us-east-1"
}

# Groupe de sécurité avec nom unique pour éviter les conflits
resource "aws_security_group" "almalek_final_sg" {
  name        = "almalek-final-sg-v2"
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
  vpc_security_group_ids = [aws_security_group.almalek_final_sg.id]

  # Installation automatique sans attendre GitHub Actions
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y nodejs npm nginx
              sudo npm install -g pm2
              EOF

  tags = {
    Name = "Almalek-Final-Instance"
  }
}

output "instance_ip" {
  value = aws_instance.app_server.public_ip
}
