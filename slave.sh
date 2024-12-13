#!/bin/bash

yum install sshpass -y

PASSWD_NEW=QwertyuioP74!#
PASSWD=`cat /var/log/mysqld.log | grep 'root@localhost:' | awk '{print $11}'`

mysql -uroot -p"$PASSWD" -e "ALTER USER USER() IDENTIFIED BY '$PASSWD_NEW';"  --connect-expired-password

sed -i 's/server-id = 1/server-id = 2/g' /etc/my.cnf.d/01-base.cnf
sed -i 's/#replicate-ignore-table=bet.events_on_demand/replicate-ignore-table=bet.events_on_demand/g' /etc/my.cnf.d/05-binlog.cnf
sed -i 's/#replicate-ignore-table=bet.v_same_event/replicate-ignore-table=bet.v_same_event/g' /etc/my.cnf.d/05-binlog.cnf

systemctl restart mysql

mysql -uroot -p"$PASSWD_NEW" -e "CREATE DATABASE bet;"
mysql -uroot -p"$PASSWD_NEW" -e "reset master;"

sshpass -p 'vagrant' scp -o "StrictHostKeyChecking no"  vagrant@192.168.56.150:/home/vagrant/master.sql /home/vagrant/master.sql

mysql -uroot -p"$PASSWD_NEW" -e "SOURCE /home/vagrant/master.sql;"
mysql -uroot -p"$PASSWD_NEW" -e "CHANGE MASTER TO MASTER_HOST = '192.168.56.150', MASTER_PORT = 3306, MASTER_USER = 'repl', MASTER_PASSWORD = '!OtusLinux2018', MASTER_AUTO_POSITION = 1;"
mysql -uroot -p"$PASSWD_NEW" -e "START SLAVE;"




