#!/bin/bash

# 如果 Apache 正在运行，则停止
if systemctl is-active --quiet httpd; then
    sudo service httpd stop
fi