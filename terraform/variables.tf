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
  default     = "" # Default to using default availability zone
}

variable "vpc_id" {
  description = "VPC ID where the EC2 instance will be launched"
  type        = string
  default     = "" # Default to using default VPC
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be launched"
  type        = string
  default     = "" # Default to using default subnet
}

variable "key_name" {
  description = "Name of the SSH key pair to use for EC2 instance"
  type        = string
  default     = "deployer-key"
}

variable "public_key" {
  description = "Public key for SSH access"
  type        = string
  default     = "" # Provide actual public key
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the EC2 instance"
  type        = string
  default     = "0.0.0.0/0" # Recommended to change to your IP
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

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "frontend_container_cpu" {
  description = "CPU units for frontend container"
  type        = number
  default     = 256
}

variable "frontend_container_memory" {
  description = "Memory for frontend container in MB"
  type        = number
  default     = 512
}

variable "backend_container_cpu" {
  description = "CPU units for backend container"
  type        = number
  default     = 256
}

variable "backend_container_memory" {
  description = "Memory for backend container in MB"
  type        = number
  default     = 512
}

variable "frontend_desired_count" {
  description = "Number of frontend tasks to run"
  type        = number
  default     = 2
}

variable "backend_desired_count" {
  description = "Number of backend tasks to run"
  type        = number
  default     = 2
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

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
} 