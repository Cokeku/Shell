#!/bin/bash
# 1. 安装nginx服务
yum install nginx -y > /dev/null 
systemctl start nginx && systemctl enable nginx

# 2. proxy_server配置文件写入
# 输入proxy监听端口: 
# 输入proxy的server_name:
# 输入调度的server及其参数:
read -p "输入配置文件名称：" filename
read -p "输入proxy监听端口:" port
read -p "输入proxy的server_name:" sername
read -p "后端节点server1：" server1
read -p "后端节点server2：" server2

cat > /etc/nginx/conf.d/$filename <<EOF
upstream webserver{
    server $server1;
    server $server2;
}

server {
    listen $port;
    server_name $sername;
    location / {
        proxy_pass http://webserver;
    }
}
EOF
# 3. 重新载入配置文件
nginx -s reload 

