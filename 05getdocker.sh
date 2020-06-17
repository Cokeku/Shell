#!/bin/bash
# step 1: 安装必要的一些系统工具
yum install -y yum-utils device-mapper-persistent-data lvm2
# Step 2: 添加软件源信息
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# Step 3: 安装Docker-CE 18.06.3.ce-3.el7
yum makecache fast
yum -y install docker-ce-18.06.3.ce-3.el7
# Step 4: 开启Docker服务并设置开机启动
systemctl start docker
systemctl enable docker
# Step 5: 通过启动hello-world验证
docker run hello-world
# Step 6： 配置镜像加速器
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://rjy7eqvs.mirror.aliyuncs.com"]
}
EOF
systemctl daemon-reload
systemctl restart docker
