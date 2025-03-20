#!/bin/bash

# 更新系统包
sudo yum update -y

# 安装 Apache 服务器
sudo yum install -y httpd

# 如果目标目录已存在，则清空
if [ -d /var/www/html ]; then
    sudo rm -rf /var/www/html/*
fi

# A停止 Apache 服务
sudo service httpd stop