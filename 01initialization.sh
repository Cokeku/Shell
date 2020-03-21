#!/bin/bash
# 初始化脚本配置
# 1.关闭防火墙和SELINUX
systemctl stop firewalld & systemctl disable firewalld
sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config

# 2.设置网卡的IP地址
read -p "请输入需要配置的网卡名称：" ETH 
read -p "请输入设置IP地址：" IP
read -p "请输入设置的网关：" GW
read -p "请输入设置的子网掩码：" MASK
read -p "请输入首选DNS服务器：" D1
read -p "请输入备选DNS服务器：" D2
 
# 3.写入到配置文件
echo 'DEVICE='$ETH'
TYPE='Ethernet'
BOOTPROTO='static'
IPADDR='$IP'
GATEWAY='$GW'
NETMASK='$MASK'
DNS1='$D1'
DNS2='$D2'' >/etc/sysconfig/network-scripts/ifcfg-$ETH

# 4.重启网卡和网络
ifdown $ETH
ifup $ETH
systemctl restart network 
