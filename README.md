# AWS Infrastructure with Terraform and GitHub Actions

This project sets up AWS infrastructure using Terraform and implements CI/CD with GitHub Actions for automatic deployment.

## Prerequisites

1. AWS Account with appropriate permissions
2. Terraform installed locally
3. GitHub repository
4. SSH key pair for EC2 access

## Setup Instructions

### 1. Configure AWS Credentials

Create a `.aws/credentials` file with your AWS credentials:
```ini
[default]
aws_access_key_id = YOUR_ACCESS_KEY
aws_secret_access_key = YOUR_SECRET_KEY
```

### 2. Set up GitHub Secrets

Add the following secrets to your GitHub repository:
- `AWS_ACCESS_KEY_ID`: Your AWS access key
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret key
- `AWS_REGION`: AWS region (default: us-east-1)
- `SSH_PRIVATE_KEY`: Your private SSH key for EC2 access
- `EC2_PUBLIC_IP`: Will be added after EC2 instance creation

### 3. Initialize and Apply Terraform

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

After applying, note the EC2 public IP from the output and add it to GitHub secrets as `EC2_PUBLIC_IP`.

### 4. Configure EC2 Instance

The EC2 instance is automatically configured with Docker during creation. The security group allows:
- SSH access (port 22)
- HTTP access to the application (port 5000)

### 5. GitHub Actions Workflow

The workflow (`backend-ecr-pipeline.yml`) will:
1. Build and push Docker image to ECR
2. SSH into EC2 instance
3. Pull the latest image
4. Stop and remove existing container
5. Run the new container

## Infrastructure Components

- **ECR Repository**: Stores Docker images
- **EC2 Instance**: Runs the application
- **Security Group**: Controls network access
- **SSH Key Pair**: Secure access to EC2

## Accessing the Application

Once deployed, the application will be available at:
```
http://<EC2_PUBLIC_IP>:5000
```

## Maintenance

To update the infrastructure:
```bash
cd terraform
terraform plan
terraform apply
```

To destroy the infrastructure:
```bash
cd terraform
terraform destroy
``` 