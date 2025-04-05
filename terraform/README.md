# Startup Incubator Infrastructure

This directory contains Terraform configurations to deploy infrastructure for the Startup Incubator application.

## Structure

```
terraform/
├── environments/
│   └── dev/               # Development environment
│       ├── main.tf        # Main configuration file
│       ├── variables.tf   # Variable definitions
│       ├── outputs.tf     # Output definitions
│       └── terraform.tfvars # Variable values
├── modules/
│   ├── ec2/               # EC2 module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security_group/    # Security group module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── iam/               # IAM module
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── README.md              # This file
```

## Prerequisites

- AWS CLI installed and configured
- Terraform v1.0.0 or later installed
- SSH key pair created in the AWS region you intend to use

## Usage

### Initialize Terraform

```bash
cd terraform/environments/dev
terraform init
```

### Plan the deployment

```bash
terraform plan
```

### Apply the configuration

```bash
terraform apply
```

When prompted, type `yes` to confirm the deployment.

### Destroy the infrastructure when done

```bash
terraform destroy
```

## Outputs

After a successful deployment, Terraform will output the following:

- `instance_id`: ID of the EC2 instance
- `instance_public_ip`: Public IP address of the EC2 instance
- `instance_public_dns`: Public DNS name of the EC2 instance
- `frontend_url`: URL to access the frontend application
- `backend_url`: URL to access the backend API

## Customizing the Deployment

You can customize the deployment by modifying the `terraform.tfvars` file in the environment directory. The following variables can be modified:

- `aws_region`: AWS region to deploy the infrastructure
- `instance_type`: Type of EC2 instance to launch
- `key_name`: Name of the SSH key pair to use
- `frontend_ecr_repo`: Name of the frontend ECR repository
- `backend_ecr_repo`: Name of the backend ECR repository
- `frontend_port`: Port to expose the frontend application
- `backend_port`: Port to expose the backend API
- `tags`: Tags to apply to all resources

## Notes

- The EC2 instance is configured to automatically pull the latest images from ECR and run them using Docker Compose.
- The IAM role attached to the EC2 instance has permissions to pull images from ECR.
- The security group is configured to allow SSH, HTTP, and API traffic. 