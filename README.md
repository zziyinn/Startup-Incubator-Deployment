# Startup Incubator Deployment

This project contains Docker containerization configurations for frontend and backend applications, using GitHub Actions to automatically build Docker images and push them to Amazon ECR.

## Project Structure

```
your-project/
│
├── .github/
│   └── workflows/
│       ├── frontend-ecr-pipeline.yml   # Frontend GitHub Actions workflow configuration
│       └── backend-ecr-pipeline.yml    # Backend GitHub Actions workflow configuration
│
├── frontend/                           # Frontend application source code
│   └── founder-bot/
│       ├── Dockerfile                  # Frontend Docker image build configuration
│       ├── .dockerignore               # Frontend Docker build ignore file
│       └── ...                         # Other frontend source code files
│
├── backend/                            # Backend application source code
│   └── founder-bot-backend/
│       ├── Dockerfile                  # Backend Docker image build configuration
│       ├── requirements.txt            # Python dependencies
│       └── ...                         # Other backend source code files
│
├── terraform/                          # Infrastructure as Code
│   ├── modules/                        # Reusable Terraform modules
│   │   ├── ec2/                        # EC2 instance module
│   │   ├── security_group/             # Security group module
│   │   └── iam/                        # IAM role and policy module
│   ├── environments/
│   │   └── dev/                        # Development environment configuration
│   └── README.md                       # Terraform documentation
│
└── README.md                           # Project documentation
```

## Configuration Details

### GitHub Actions Workflows

This project configures two independent GitHub Actions workflows:

1. **Frontend Workflow** (`.github/workflows/frontend-ecr-pipeline.yml`)
   - Triggered when code in the `frontend` directory changes
   - Builds the frontend Docker image and pushes it to the ECR repository `frontend-repo`
   - Uses Node.js to build the application with Nginx as the web server

2. **Backend Workflow** (`.github/workflows/backend-ecr-pipeline.yml`)
   - Triggered when code in the `backend` directory changes
   - Builds the backend Docker image and pushes it to the ECR repository `backend-repo`
   - Uses Python to run the backend service

### Optimization Features

Both workflows include the following optimization features:

- **Docker Buildx**: For more efficient builds
- **Layer Caching**: To speed up subsequent builds
- **Multi-architecture Support**: Compatible with linux/amd64 architecture
- **Automatic ECR Repository Creation**: Creates repositories automatically if they don't exist
- **Multiple Tags**: Each image uses both the commit SHA and `latest` tags

### Infrastructure as Code

The project uses Terraform to automate the deployment of AWS infrastructure:

- **EC2 Instance**: Hosts both frontend and backend applications
- **Security Groups**: Control network access to the instance
- **IAM Roles**: Provide necessary permissions for ECR access
- **Docker Compose**: Automatically pulls and runs the application containers

### Prerequisites

- AWS account with ECR access permissions
- GitHub repository
- Docker installed locally for testing
- Terraform v1.0.0 or later for infrastructure deployment

### GitHub Secrets Configuration

Configure the following Secrets in your GitHub repository:

- `AWS_ACCESS_KEY_ID`: Your AWS access key
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret access key
- `AWS_REGION`: AWS region (e.g., `us-east-1`, `ap-northeast-1`, etc.)

## Local Testing

### Testing the Frontend Docker Image

```bash
cd frontend/founder-bot
# Use the same Dockerfile configuration as in the workflow
cat > Dockerfile.local << 'EOF'
FROM node:18-alpine as builder
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

docker build -t frontend-app -f Dockerfile.local .
docker run -p 80:80 frontend-app
```

Visit http://localhost to view the frontend application

### Testing the Backend Docker Image

```bash
cd backend/founder-bot-backend
docker build -t backend-app .
docker run -p 5000:5000 backend-app
```

Visit http://localhost:5000 to test the backend API

## Deployment Process

1. Push code to the `main` branch of your GitHub repository
2. GitHub Actions workflows will automatically:
   - Build Docker images
   - Push them to Amazon ECR
   - Tag them with both commit SHA and 'latest'

3. For infrastructure deployment:
   ```bash
   cd terraform/environments/dev
   terraform init
   terraform apply
   ```

## Manually Triggering Workflows

If you need to manually trigger the workflows, you can select the appropriate workflow in the Actions tab of your GitHub repository and click the "Run workflow" button.

## Troubleshooting

If the build fails, check:

1. **GitHub Secrets**: Ensure all required AWS credentials are correctly configured
2. **IAM Permissions**: Verify that the IAM user has sufficient ECR permissions
3. **Dependencies**: Check if dependencies in frontend `package.json` and backend `requirements.txt` are correct
4. **Workflow Logs**: Examine GitHub Actions logs for detailed error information
5. **Terraform State**: For infrastructure issues, check the Terraform state and error messages

## License

MIT License

## Updates

### v1.0.0 (2024-04-05)
- Initial release with Docker containerization for frontend and backend
- Added GitHub Actions workflows for ECR deployment
- Created temporary frontend and backend applications

### v1.1.0 (2024-04-05)
- Added Terraform infrastructure as code
- Created EC2, Security Group, and IAM modules
- Implemented automatic deployment of containerized applications
- Translated documentation to English
