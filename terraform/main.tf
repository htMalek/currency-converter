provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0c02fb55956c7d316" # Ubuntu (à ajuster si besoin)
  instance_type = "t2.large"
  key_name      = "vockey"

  tags = {
    Name = "currency-converter"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y nodejs npm git nginx

              # Installer Node 20
              curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
              apt install -y nodejs

              # Cloner ton repo
              cd /home/ubuntu
              git clone https://github.com/htMalek/currency-converter.git
              cd currency-converter/backend
              npm install

              cd ../frontend
              npm install
              npm run build

              # Copier frontend vers nginx
              rm -rf /var/www/html/*
              cp -r dist/* /var/www/html/

              # Lancer backend
              cd ../backend
              nohup node server.js &

              systemctl restart nginx
              EOF
}
