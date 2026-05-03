provider "aws" {
  region = "us-east-1" # Virginia (Région AWS Academy par défaut)
}

# 1. Configuration du Groupe de Sécurité
resource "aws_security_group" "app_sg_v3" {
  name        = "almalek-currency-sg-v3" # Nom unique pour éviter l'erreur "Duplicate"
  description = "Autorise SSH et le trafic Web"

  # Accès SSH pour le déploiement (Job 2 et 3)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Accès HTTP pour voir ton application
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Port pour le Backend Node.js (si tu veux tester l'API directement)
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Autoriser toute la sortie (indispensable pour npm install)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Configuration de l'Instance EC2
resource "aws_instance" "app_server" {
  ami           = "ami-04b70fa74e45c3917" # Ubuntu 24.04 LTS (Noble Numbat)
  instance_type = "t2.large"
  key_name      = "vockey" # Utilise la clé pré-configurée d'AWS Academy
  
  vpc_security_group_ids = [aws_security_group.app_sg_v3.id]

  tags = {
    Name = "Almalek-Converter-Instance"
  }

  # Petite astuce : installation de base dès le démarrage
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y nodejs npm nginx
              EOF
}

# 3. Sortie de l'IP (nécessaire pour le pipeline)
output "instance_ip" {
  value = aws_instance.app_server.public_ip
}
