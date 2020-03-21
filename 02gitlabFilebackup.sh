#!/bin/bash
#zhao.hao
#Wed Apr 10 03:03:06 EDT 2019
#该脚本的主要目的是用来每日备份gitlab文件以及删除三天前的备份文件
GitlabFileDir="/var/opt/gitlab/backups/"
time=3
backup(){
gitlab-rake gitlab:backup:create
}
deletebak(){
find $GitlabFileDir -ctime +$time  -type f -exec rm -rf  {} \;
}
#备份文件
backup
#删除备份文件
deletebak
#周期性执行任务
echo "0 10 * * * /root/GitlabFileBackup" >> /var/spool/cron/root 
