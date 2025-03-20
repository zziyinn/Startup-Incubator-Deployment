#!/bin/bash

# 启动 Apache 服务器
sudo service httpd start

# 设置 Apache 在系统启动时自动启动
sudo chkconfig httpd on