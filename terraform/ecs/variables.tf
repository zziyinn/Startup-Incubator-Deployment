variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region where resources will be created"
}

variable "project_name" {
  type        = string
  default     = "startup-incubator"
  description = "Project name used for resource naming"
}

variable "environment" {
  type        = string
  default     = "production"
  description = "Environment name (e.g. development, staging, production)"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for VPC"
}

variable "az_count" {
  type        = number
  default     = 2
  description = "Number of availability zones to use"
}

variable "ecs_task_execution_role" {
  default     = "myECcsTaskExecutionRole"
  description = "ECS task execution role name"
}

variable "frontend_image" {
  type        = string
  description = "Docker image for frontend service"
}

variable "backend_image" {
  type        = string
  description = "Docker image for backend service"
}

variable "frontend_port" {
  type        = number
  default     = 80
  description = "Port for frontend service"
}

variable "backend_port" {
  type        = number
  default     = 5000
  description = "Port for backend service"
}

variable "frontend_cpu" {
  type        = number
  default     = 256
  description = "CPU units for frontend task"
}

variable "frontend_memory" {
  type        = number
  default     = 512
  description = "Memory for frontend task (MiB)"
}

variable "backend_cpu" {
  type        = number
  default     = 256
  description = "CPU units for backend task"
}

variable "backend_memory" {
  type        = number
  default     = 512
  description = "Memory for backend task (MiB)"
}

variable "desired_count" {
  type        = number
  default     = 2
  description = "Number of tasks to run"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags for all resources"
}
