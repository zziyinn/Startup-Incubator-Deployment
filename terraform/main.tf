terraform {
  backend "s3" {
    bucket = "startup-incubator-terraform-state"
    key    = "state/ec2-state.tfstate"
    region = "us-east-2"
  }
}

# Provider configuration
provider "aws" {
  region = "us-east-2"
}

# Create a security group
resource "aws_security_group" "app" {
  name        = "startup-incubator-sg"
  description = "Security group for startup incubator application"
  
  # SSH access
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Frontend access
  ingress {
    description = "HTTP on port 3000"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Backend access
  ingress {
    description = "HTTP on port 5000"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Additional ports for other services
  ingress {
    description = "HTTP on port 3001"
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP on port 5001"
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "startup-incubator-sg"
  }
}

# Generate a key pair
resource "aws_key_pair" "deployer" {
  key_name   = "startup-incubator-key"
  public_key = file("${path.module}/id_ed.pub")
}

# Launch EC2 instance
resource "aws_instance" "app" {
  ami           = "ami-0b4624933067d393a"  # Amazon Linux 2
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name

  vpc_security_group_ids = [aws_security_group.app.id]

  root_block_device {
    volume_size = 20  # Set the root volume size to 20GB
  }

  # User data script for installing Docker and Docker Compose
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker
              service docker start
              usermod -a -G docker ec2-user
              curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              EOF

  tags = {
    Name = "startup-incubator-app"
  }
}
