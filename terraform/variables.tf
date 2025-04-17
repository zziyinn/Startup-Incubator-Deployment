variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "availability_zone" {
  description = "Availability zone for the EC2 instance"
  type        = string
  default     = "" # 默认使用默认可用区
}

variable "vpc_id" {
  description = "VPC ID where the EC2 instance will be launched"
  type        = string
  default     = "" # 默认使用默认 VPC
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be launched"
  type        = string
  default     = "" # 默认使用默认子网
}

variable "key_name" {
  description = "Name of the SSH key pair to use for EC2 instance"
  type        = string
  default     = "deployer-key"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the EC2 instance"
  type        = string
  default     = "0.0.0.0/0" # 建议修改为你的 IP
}

variable "allowed_http_cidr" {
  description = "CIDR block allowed to access the HTTP service"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "backend-repo"
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = "ec2-security-group"
}

variable "ebs_volume_size" {
  description = "Size of the EBS volume in GB"
  type        = number
  default     = 20
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "startup-incubator"
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "startup-incubator"
    ManagedBy   = "terraform"
  }
} 