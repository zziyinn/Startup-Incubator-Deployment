provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "security_group" {
  source = "../../modules/security_group"

  name        = "startup-incubator-sg"
  description = "Security group for Startup Incubator app"
  vpc_id      = data.aws_vpc.default.id

  ingress_rules = [
    {
      description = "SSH from anywhere"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTP for frontend"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Backend API"
      from_port   = 5000
      to_port     = 5000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = var.tags
}

module "iam" {
  source = "../../modules/iam"

  role_name             = "startup-incubator-role"
  instance_profile_name = "startup-incubator-profile"
  tags                  = var.tags
}

module "ec2_instance" {
  source = "../../modules/ec2"

  name                        = "startup-incubator-instance"
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = element(data.aws_subnets.default.ids, 0)
  vpc_security_group_ids      = [module.security_group.id]
  associate_public_ip_address = true
  key_name                    = var.key_name
  iam_instance_profile        = module.iam.instance_profile_name
  aws_region                  = var.aws_region
  frontend_ecr_repo           = var.frontend_ecr_repo
  backend_ecr_repo            = var.backend_ecr_repo
  frontend_port               = var.frontend_port
  backend_port                = var.backend_port

  tags = var.tags
} 