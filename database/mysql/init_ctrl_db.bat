@echo off
echo initialize control db...
set hostIp=%1
set username=%2
set password=%3
set dbName=%4
echo backup control db...
mysqldump -h %hostIp% -u%username% -p%password% %dbName% > ctrl_db_backup.sql
echo finished backup!

mysqladmin -h %hostIp% -u%username% -p%password% drop %dbName%
mysql -h %hostIp% -u%username% -p%password% < ctrl_db20140316.sql 
echo finished control db initialization !

