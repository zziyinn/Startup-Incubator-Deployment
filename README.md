# Startup Incubator Deployment

This repository contains a containerized application configured for continuous deployment using GitHub Actions and Amazon ECR.

## Project Structure

```
your-project/
│
├── .github/
│   └── workflows/
│       └── ecr-push.yml       # GitHub Actions workflow configuration
│
├── src/                       # Application source code
│   ├── ...
│   └── ...
│
├── Dockerfile                 # Docker image build configuration
├── .dockerignore              # Specifies files to ignore during Docker build
├── package.json               # For Node.js projects
├── requirements.txt           # For Python projects
└── README.md                  # Project documentation
```

## Setup Instructions

### Prerequisites

- AWS account with ECR access
- GitHub repository
- Docker installed locally for testing

### GitHub Secrets Configuration

Configure the following secrets in your GitHub repository:

- `AWS_ACCESS_KEY_ID`: Your AWS access key with ECR permissions
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret access key
- `AWS_REGION`: The AWS region where your ECR repository is located
- `ECR_REPOSITORY`: (Optional) Name of your ECR repository (defaults to 'my-app-repo')

### Deployment Process

1. Push changes to the `main` branch
2. GitHub Actions workflow will automatically:
   - Build the Docker image
   - Push to Amazon ECR
   - Tag with both commit SHA and 'latest'

## Local Development

To build and test locally:

```bash
# Build the Docker image
docker build -t my-app .

# Run the container
docker run -p 8080:8080 my-app
```

## License

[Your license information]