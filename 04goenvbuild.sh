#!/bin/bash
# 1.下载安装包并解压
curl -O https://dl.google.com/go/go1.13.9.linux-amd64.tar.gz
tar -zxvf go1.13.9.linux-amd64.tar.gz -C /usr/local/ > /dev/null 

# 2. 设置环境变量
echo 'export GOROOT=/usr/local/go/' >> /etc/profile 
echo 'export PATH=$PATH:$GOROOT/bin' >> /etc/profile

# 3. 环境变量生效并测试清理
source /etc/profile
go version
if [ $? -eq 0 ];then
    rm -rf go1.13.9.linux-amd64.tar.gz
    echo "安装成功！"
else 
    echo "安装失败"
fi
