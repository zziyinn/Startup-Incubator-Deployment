resource "aws_instance" "this" {
  ami                         = var.ami
  instance_type               = var.instance_type
  user_data                   = var.user_data
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  monitoring                  = var.monitoring
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = var.iam_instance_profile

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags,
  )

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  # User data script to install Docker, configure AWS CLI, and run containers
  user_data = <<-EOF
    #!/bin/bash
    set -e

    # Update and install dependencies
    yum update -y
    yum install -y docker amazon-ecr-credential-helper jq aws-cli

    # Start Docker service
    systemctl start docker
    systemctl enable docker

    # Add ec2-user to docker group
    usermod -a -G docker ec2-user

    # Configure Docker to use ECR credential helper
    mkdir -p /home/ec2-user/.docker
    cat > /home/ec2-user/.docker/config.json <<'DOCKERCONFIG'
    {
      "credHelpers": {
        "${var.aws_region}.dkr.ecr.${var.aws_region}.amazonaws.com": "ecr-login"
      }
    }
    DOCKERCONFIG
    chown -R ec2-user:ec2-user /home/ec2-user/.docker

    # Set AWS region
    aws configure set region ${var.aws_region}

    # Login to ECR
    aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query Account --output text).dkr.ecr.${var.aws_region}.amazonaws.com

    # Pull latest images
    ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
    FRONTEND_IMAGE=$ACCOUNT_ID.dkr.ecr.${var.aws_region}.amazonaws.com/${var.frontend_ecr_repo}:latest
    BACKEND_IMAGE=$ACCOUNT_ID.dkr.ecr.${var.aws_region}.amazonaws.com/${var.backend_ecr_repo}:latest

    docker pull $FRONTEND_IMAGE
    docker pull $BACKEND_IMAGE

    # Create docker-compose.yml
    cat > /home/ec2-user/docker-compose.yml <<'COMPOSE'
    version: '3'
    services:
      frontend:
        image: $FRONTEND_IMAGE
        ports:
          - "${var.frontend_port}:80"
        restart: always
        depends_on:
          - backend

      backend:
        image: $BACKEND_IMAGE
        ports:
          - "${var.backend_port}:5000"
        restart: always
        environment:
          - FLASK_ENV=production
    COMPOSE

    # Install docker-compose
    curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

    # Replace variables in docker-compose.yml
    sed -i "s|\$FRONTEND_IMAGE|$FRONTEND_IMAGE|g" /home/ec2-user/docker-compose.yml
    sed -i "s|\$BACKEND_IMAGE|$BACKEND_IMAGE|g" /home/ec2-user/docker-compose.yml

    # Run containers with docker-compose
    cd /home/ec2-user
    docker-compose up -d

    # Create a startup script that will be run on system boot
    cat > /etc/systemd/system/docker-compose-app.service <<'SERVICEFILE'
    [Unit]
    Description=Docker Compose Application Service
    Requires=docker.service
    After=docker.service

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    WorkingDirectory=/home/ec2-user
    ExecStart=/usr/local/bin/docker-compose up -d
    ExecStop=/usr/local/bin/docker-compose down
    TimeoutStartSec=0

    [Install]
    WantedBy=multi-user.target
    SERVICEFILE

    # Enable and start the service
    systemctl enable docker-compose-app
    systemctl start docker-compose-app

    # Create a health check script
    cat > /home/ec2-user/health_check.sh <<'HEALTHCHECK'
    #!/bin/bash
    frontend_running=$(docker ps | grep frontend | wc -l)
    backend_running=$(docker ps | grep backend | wc -l)

    if [ $frontend_running -eq 0 ] || [ $backend_running -eq 0 ]; then
      echo "One or more containers are not running"
      cd /home/ec2-user
      docker-compose up -d
    else
      echo "All containers are running"
    fi
    HEALTHCHECK

    chmod +x /home/ec2-user/health_check.sh

    # Add health check to crontab
    echo "*/5 * * * * /home/ec2-user/health_check.sh >> /home/ec2-user/health_check.log 2>&1" | crontab -
  EOF
} 