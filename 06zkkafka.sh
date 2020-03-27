#!/bin/bash 

# 1.准备zookeeper和kafka镜像
docker pull wurstmeister/zookeeper
docker pull wurstmeister/kafka

read -p "请输宿主机IP地址: " IP   
# 2.启动zookeeper 
docker run --name zookeeper --restart always -d \ 
    -p 2181:2181 \
    -v $(pwd)/zoo.cfg:/conf/zoo.cfg \
    -v $(pwd)/data:/data \
    -v $(pwd)/log:/log \
    wurstmeister/zookeeper

# 3.启动kafka
docker run -d --name kafka --restart always -d  \
    -p 9092:9092 \
    --env KAFKA_ADVERTISED_HOST_NAME=localhost \
    --env KAFKA_ZOOKEEPER_CONNECT=${IP}:2181 \
    --env KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://${IP}:9092 \
    --env KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092 \
    --env KAFKA_HEAP_OPTS="-Xmx256M -Xms128M" \
    wurstmeister/kafka

# 测试：
# docker exec -it kafka /bin/bash 
# # 进入kafka的bin目录
# cd /opt/kafka_2.12-2.4.1/bin/
# ./kafka-topics.sh --create --zookeeper 192.168.10.20:2181 --replication-factor 1 --partitions 1 --topic test
# ./kafka-console-producer.sh --broker-list 192.168.10.20:9092 --topic test
# >hello # 发送一条消息并回车
# >world

# docker exec -it kafka /bin/bash
# # 进入kafka的bin目录
# cd /opt/kafka_2.12-2.4.1/bin/
# # 以消费者身份接收消息
# ./kafka-console-consumer.sh --bootstrap-server 192.168.10.20:9092 --topic test --from-beginning
# hello # 成功接收到消息
# world