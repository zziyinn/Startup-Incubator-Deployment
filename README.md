# Startup Incubator Deployment

This project demonstrates the deployment of a startup incubator application using modern DevOps practices.

## Recent Updates (April 2024)

### April 12, 2024
- Implemented EC2 deployment with Terraform
- Configured automatic deployment through GitHub Actions
- Set up Docker containerization for frontend and backend
- Added security group configurations for EC2 instance
- Automated ECR image pulling and container deployment
- Added EC2 deployment workflow configuration

### April 11, 2024
- Created ECR repositories for frontend and backend
- Set up GitHub Actions workflows for ECR image building
- Implemented automated image pushing to ECR
- Added Dockerfile configurations for both services

### April 10, 2024
- Initialized project structure
- Set up basic infrastructure
- Created deployment configurations

## Project Structure

```
.
├── .github/
│   └── workflows/
│       ├── frontend-ecr-pipeline.yml
│       ├── backend-ecr-pipeline.yml
│       └── ec2-deployment.yml
├── terraform/
│   └── environments/
│       └── prod/
│           ├── main.tf
│           └── outputs.tf
└── deployment/
    ├── docker-compose.yml
    └── nginx.conf
```

## Features

- **Infrastructure as Code**: Using Terraform for AWS resource management
- **CI/CD Pipeline**: Automated deployment through GitHub Actions
- **Containerization**: Docker-based deployment for both frontend and backend
- **Security**: Configured security groups and access controls
- **Scalability**: Designed for easy scaling and maintenance

## Deployment Process

1. **Image Building**:
   - Frontend and backend images are built and pushed to ECR
   - Automated through GitHub Actions

2. **Infrastructure Deployment**:
   - EC2 instance is created with Terraform
   - Security groups are configured
   - Docker is installed and configured

3. **Application Deployment**:
   - Images are pulled from ECR
   - Containers are started using docker-compose
   - Services are automatically restarted on failure

## GitHub Actions Workflows

### EC2 Deployment Workflow
The EC2 deployment workflow (`ec2-deployment.yml`) is triggered on:
- Push to main branch (when Terraform files change)
- Manual trigger through workflow_dispatch

Workflow steps:
1. Checkout code
2. Configure AWS credentials
3. Setup Terraform
4. Initialize Terraform
5. Plan infrastructure changes
6. Apply infrastructure changes
7. Output EC2 instance information

Required GitHub Secrets:
- `AWS_ACCESS_KEY_ID`: AWS access key
- `AWS_SECRET_ACCESS_KEY`: AWS secret key

## Accessing the Application

- **Frontend**: `http://<EC2_PUBLIC_IP>`
- **Backend**: `http://<EC2_PUBLIC_IP>:5000`

## Requirements

- AWS Account with appropriate permissions
- GitHub repository with configured secrets
- Terraform 1.0.0 or later
- Docker and docker-compose

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 