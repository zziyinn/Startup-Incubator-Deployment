#!/bin/bash

# Set variables
AWS_ACCOUNT_ID="your-aws-account-id"
AWS_REGION="your-region"
ECR_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
FRONTEND_REPO="frontend-repo"
BACKEND_REPO="backend-repo"

# Login to ECR
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_URL}

# Pull latest images
docker pull ${ECR_URL}/${FRONTEND_REPO}:latest
docker pull ${ECR_URL}/${BACKEND_REPO}:latest

# Stop and remove old containers
docker stop frontend backend || true
docker rm frontend backend || true

# Run new containers
docker run -d -p 3000:3000 --name frontend ${ECR_URL}/${FRONTEND_REPO}:latest
docker run -d -p 5000:5000 --name backend ${ECR_URL}/${BACKEND_REPO}:latest

echo "Deployment completed!"