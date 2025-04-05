variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair to use for EC2 instance"
  type        = string
  default     = ""
}

variable "frontend_ecr_repo" {
  description = "Name of the ECR repository for frontend"
  type        = string
  default     = "startup-incubator-frontend"
}

variable "backend_ecr_repo" {
  description = "Name of the ECR repository for backend"
  type        = string
  default     = "startup-incubator-backend"
}

variable "frontend_port" {
  description = "Port number for the frontend application"
  type        = number
  default     = 80
}

variable "backend_port" {
  description = "Port number for the backend application"
  type        = number
  default     = 5000
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "startup-incubator"
    Terraform   = "true"
  }
} 