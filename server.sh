#!/bin/bash

PASSWD_NEW=QwertyuioP74!#
PASSWD=`cat /var/log/mysqld.log | grep 'root@localhost:' | awk '{print $11}'`

mysql -uroot -p"$PASSWD" -e "ALTER USER USER() IDENTIFIED BY '$PASSWD_NEW';"  --connect-expired-password

mysql -uroot -p"$PASSWD_NEW" -e "CREATE DATABASE bet;"

mysql -uroot -p"$PASSWD_NEW" -D bet < /vagrant/bet.dmp

mysql -uroot -p"$PASSWD_NEW" -e "CREATE USER 'repl'@'%' IDENTIFIED BY '!OtusLinux2018';"  --connect-expired-password

mysql -uroot -p"$PASSWD_NEW" -e "GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%' IDENTIFIED BY '!OtusLinux2018';"  --connect-expired-password

mysql -uroot -p"$PASSWD_NEW" -e " reset master;"

mysqldump --all-databases --triggers --routines --master-data --ignore-table=bet.events_on_demand --ignore-table=bet.v_same_event -uroot -p"$PASSWD_NEW" > /home/vagrant/master.sql

