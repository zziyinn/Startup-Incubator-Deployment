#!/bin/bash

# 设置正确的权限
sudo chown -R apache:apache /var/www/html/

# 如果 SELinux 已启用，设置适当的安全上下文
if [ -x "$(command -v sestatus)" ] && [ "$(sestatus | grep -c "enabled")" -gt 0 ]; then
    sudo restorecon -Rv /var/www/html
fi