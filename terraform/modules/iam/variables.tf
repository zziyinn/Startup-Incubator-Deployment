variable "role_name" {
  description = "Name of the IAM role"
  type        = string
  default     = "ec2-ecr-access-role"
}

variable "instance_profile_name" {
  description = "Name of the instance profile"
  type        = string
  default     = "ec2-ecr-access-profile"
}

variable "tags" {
  description = "A mapping of tags to assign to IAM role"
  type        = map(string)
  default     = {}
} 