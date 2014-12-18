#!/bin/bash

curDate=`date "+%Y-%m-%d"`
curTime=`date "+%H-%M-%S"`
dbUser='test'
dbPwd='123'
[ ! -d /var/dbbackup/$curDate ] && mkdir -p /var/dbbackup/$curDate
cd /var/dbbackup/$curDate

# 2014-12-18_00-02-30.tar.gz
backupFile=$curDate"_"$curTime
mysqldump -u$dbUser -p$dbPwd ctrl_db > $backupFile"-ctrl.sql"
mysqldump -u$dbUser -p$dbPwd res_db > $backupFile"-res.sql"
cd ..
if [ -a $backupFile.tar.gz ]; then
        rm $backupFile.tar.gz
fi
tar -czf $backupFile.tar.gz $curDate --remove-files


## crontab config
# 0 0 * * 2,4,6 /root/db_backup/backup_db.sh 2>&1 >> /dev/null
