# !/bin/bash

# 1.准备镜像
docker image pull registry.cn-hangzhou.aliyuncs.com/coreos_etcd/etcd:v3
docker image tag registry.cn-hangzhou.aliyuncs.com/coreos_etcd/etcd:v3 gcr.io/etcd-development/etcd:v3

# 2.清除本地挂载文件
rm -rf /tmp/etcd-data.tmp
mkdir -p /tmp/etcd-data.tmp

# 3.启动容器
docker rm -f etcd-gcr-v3 &> /dev/null
docker run -p 2379:2379 -d -e ETCDCTL_API="3" \
    --restart always \
    --mount type=bind,source=/tmp/etcd-data.tmp,destination=/etcd-data \
    --name etcd-gcr-v3 \
    gcr.io/etcd-development/etcd:v3 \
    /usr/local/bin/etcd \
    --name s1 \
    --data-dir /etcd-data \
    --listen-client-urls http://0.0.0.0:2379 \
    --advertise-client-urls http://0.0.0.0:2379 

# 4.测试
docker exec etcd-gcr-v3 /bin/sh -c "/usr/local/bin/etcd --version"
docker exec etcd-gcr-v3 /bin/sh -c "/usr/local/bin/etcdctl version"
docker exec etcd-gcr-v3 /bin/sh -c "/usr/local/bin/etcdctl endpoint health"
docker exec etcd-gcr-v3 /bin/sh -c "/usr/local/bin/etcdctl put foo bar"
docker exec etcd-gcr-v3 /bin/sh -c "/usr/local/bin/etcdctl get foo"