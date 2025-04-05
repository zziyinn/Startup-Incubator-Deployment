output "role_name" {
  description = "The name of the IAM role"
  value       = aws_iam_role.ec2_ecr_role.name
}

output "role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.ec2_ecr_role.arn
}

output "instance_profile_name" {
  description = "The name of the instance profile"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "instance_profile_arn" {
  description = "The ARN of the instance profile"
  value       = aws_iam_instance_profile.ec2_profile.arn
} 