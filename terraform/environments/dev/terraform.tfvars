aws_region       = "us-east-1"
instance_type    = "t2.micro"
key_name         = "startup-incubator-key"  # Change this to your actual SSH key name
frontend_ecr_repo = "startup-incubator-frontend"
backend_ecr_repo  = "startup-incubator-backend"
frontend_port    = 80
backend_port     = 5000

tags = {
  Environment = "dev"
  Project     = "startup-incubator"
  Terraform   = "true"
  Owner       = "devops-team"
} 