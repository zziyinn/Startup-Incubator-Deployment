terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# IAM Role for EC2
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.project_name}-ec2-role"
  })
}

# IAM Policy for ECR access
resource "aws_iam_role_policy" "ecr_access" {
  name = "${var.project_name}-ecr-access"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# ECR Repository
resource "aws_ecr_repository" "backend" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(var.tags, {
    Name = var.ecr_repository_name
  })
}

# ECR Lifecycle Policy
resource "aws_ecr_lifecycle_policy" "backend" {
  repository = aws_ecr_repository.backend.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 30 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 30
      }
      action = {
        type = "expire"
      }
    }]
  })
}

# Security Group for EC2
resource "aws_security_group" "ec2_sg" {
  name        = var.security_group_name
  description = "Security group for EC2 instance"
  vpc_id      = var.vpc_id != "" ? var.vpc_id : null

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = [var.allowed_http_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = var.security_group_name
  })
}

# EBS Volume
resource "aws_ebs_volume" "app_data" {
  availability_zone = var.availability_zone != "" ? var.availability_zone : aws_instance.app_server.availability_zone
  size              = var.ebs_volume_size
  type              = "gp3"

  tags = merge(var.tags, {
    Name = "${var.project_name}-data-volume"
  })
}

# EBS Volume Attachment
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.app_data.id
  instance_id = aws_instance.app_server.id
}

# EC2 Instance
resource "aws_instance" "app_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = var.key_name
  subnet_id              = var.subnet_id != "" ? var.subnet_id : null
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  availability_zone      = var.availability_zone != "" ? var.availability_zone : null

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ubuntu
              
              # Mount EBS volume
              sudo mkfs -t ext4 /dev/sdh
              sudo mkdir -p /data
              sudo mount /dev/sdh /data
              echo '/dev/sdh /data ext4 defaults,nofail 0 2' | sudo tee -a /etc/fstab
              EOF

  tags = merge(var.tags, {
    Name = "${var.project_name}-app-server"
  })
}

# SSH Key Pair
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file("~/.ssh/id_rsa.pub")

  tags = merge(var.tags, {
    Name = var.key_name
  })
}

# Outputs
output "ec2_public_ip" {
  value = aws_instance.app_server.public_ip
}

output "ecr_repository_url" {
  value = aws_ecr_repository.backend.repository_url
}

output "ec2_instance_id" {
  value = aws_instance.app_server.id
}

output "security_group_id" {
  value = aws_security_group.ec2_sg.id
} 