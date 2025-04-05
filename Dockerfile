# Using multi-stage builds for optimization
# ============= BUILD STAGE =============
FROM node:18-alpine AS node_builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM python:3.9-slim AS python_builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
# For Python applications that need to be built/compiled
# RUN python -m compileall .

# ============= FINAL STAGE =============
# Uncomment ONE of these sections based on your application type

# Node.js Application (uncomment if using Node.js)
FROM node:18-alpine
WORKDIR /app
COPY --from=node_builder /app/node_modules ./node_modules
COPY --from=node_builder /app/dist ./dist
COPY --from=node_builder /app/package*.json ./
# Add any additional files needed for production
EXPOSE 8080
CMD ["npm", "start"]

# Python Application (comment out if using Node.js)
# FROM python:3.9-slim
# WORKDIR /app
# COPY --from=python_builder /app .
# COPY --from=python_builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
# EXPOSE 8080
# CMD ["python", "src/main.py"]

# Note: Before running the build, edit this file to keep only one of the final stages
# and remove the other commented section to avoid confusion. 