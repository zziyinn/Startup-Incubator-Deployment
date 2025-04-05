# Startup Incubator Deployment

本项目包含前端和后端应用程序的 Docker 容器化配置，使用 GitHub Actions 自动构建 Docker 镜像并推送到 Amazon ECR。

## 项目结构

```
your-project/
│
├── .github/
│   └── workflows/
│       ├── docker-ecr-frontend.yml   # 前端 GitHub Actions 工作流配置
│       └── docker-ecr-backend.yml    # 后端 GitHub Actions 工作流配置
│
├── frontend/                         # 前端应用源代码
│   └── founder-bot/
│       ├── Dockerfile                # 前端 Docker 镜像构建配置
│       ├── .dockerignore             # 前端 Docker 构建忽略文件
│       └── ...                       # 其他前端源代码文件
│
├── backend/                          # 后端应用源代码
│   └── founder-bot-backend/
│       ├── Dockerfile                # 后端 Docker 镜像构建配置
│       ├── requirements.txt          # Python 依赖
│       └── ...                       # 其他后端源代码文件
│
└── README.md                         # 项目说明文档
```

## 配置说明

### GitHub Actions 工作流

本项目配置了两个独立的 GitHub Actions 工作流：

1. **前端工作流** (`.github/workflows/docker-ecr-frontend.yml`)
   - 当 `frontend` 目录中的代码发生变化时触发
   - 构建前端 Docker 镜像并推送到 ECR 仓库 `frontend-repo`

2. **后端工作流** (`.github/workflows/docker-ecr-backend.yml`)
   - 当 `backend` 目录中的代码发生变化时触发
   - 构建后端 Docker 镜像并推送到 ECR 仓库 `backend-repo`

### 前提条件

- AWS 账户，具有 ECR 访问权限
- GitHub 仓库
- 本地安装 Docker 用于测试

### GitHub Secrets 配置

在 GitHub 仓库中配置以下 Secrets：

- `AWS_ACCESS_KEY_ID`: 您的 AWS 访问密钥
- `AWS_SECRET_ACCESS_KEY`: 您的 AWS 秘密访问密钥
- `AWS_REGION`: AWS 区域（例如 `us-east-1`、`ap-northeast-1` 等）

## 本地测试

### 测试前端 Docker 镜像

```bash
cd frontend/founder-bot
docker build -t frontend-app .
docker run -p 3000:3000 frontend-app
```

### 测试后端 Docker 镜像

```bash
cd backend/founder-bot-backend
docker build -t backend-app .
docker run -p 5000:5000 backend-app
```

## 部署流程

1. 推送代码到 GitHub 仓库的 `main` 分支
2. GitHub Actions 工作流会自动：
   - 构建 Docker 镜像
   - 推送到 Amazon ECR
   - 使用 commit SHA 和 'latest' 标签

## 手动触发工作流

如果需要手动触发工作流，可以在 GitHub 仓库的 Actions 标签页中选择相应的工作流，点击 "Run workflow" 按钮。

## License

[Your license information]