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
   - 使用 Node.js 构建应用程序并使用 Nginx 作为 Web 服务器

2. **后端工作流** (`.github/workflows/docker-ecr-backend.yml`)
   - 当 `backend` 目录中的代码发生变化时触发
   - 构建后端 Docker 镜像并推送到 ECR 仓库 `backend-repo`
   - 使用 Python 运行后端服务

### 优化特性

两个工作流都包含以下优化特性：

- **Docker Buildx**：用于更高效的构建
- **层缓存**：加速后续构建
- **多架构支持**：支持 linux/amd64 架构
- **自动创建 ECR 仓库**：如果仓库不存在会自动创建
- **多标签**：每个镜像同时使用 commit SHA 和 `latest` 标签

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
# 使用工作流中相同的 Dockerfile 配置
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

访问 http://localhost 查看前端应用

### 测试后端 Docker 镜像

```bash
cd backend/founder-bot-backend
docker build -t backend-app .
docker run -p 5000:5000 backend-app
```

访问 http://localhost:5000 测试后端 API

## 部署流程

1. 推送代码到 GitHub 仓库的 `main` 分支
2. GitHub Actions 工作流会自动：
   - 构建 Docker 镜像
   - 推送到 Amazon ECR
   - 使用 commit SHA 和 'latest' 标签

## 手动触发工作流

如果需要手动触发工作流，可以在 GitHub 仓库的 Actions 标签页中选择相应的工作流，点击 "Run workflow" 按钮。

## 故障排除

如果构建失败，请检查：

1. **GitHub Secrets**: 确保所有必需的 AWS 凭证已正确配置
2. **IAM 权限**: 确保 IAM 用户有足够的 ECR 权限
3. **依赖项**: 前端 `package.json` 和后端 `requirements.txt` 中的依赖是否正确
4. **工作流日志**: 查看 GitHub Actions 日志获取详细错误信息

## 许可证

[Your license information]