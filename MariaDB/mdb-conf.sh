#!/bin/bash

#++++++ mariadb start ++++++#
service mariadb start # start mariadb
sleep 5 # wait for mariadb to start

#+++++ mariadb config +++++#
# Create database if not exists
mariadb -e "CREATE DATABASE IF NOT EXIST \`${MYSQL_DB}\`";

# Create user if not exists
mariadb -e "GRANT ALL PRIVILEGES ON ${MYSQL_DB}.* TO \`${MYSQL_USER}\`@'%';"

# Flush privileges to apply changes
mariadb -e "FLUSH PRIVILEGES;"

#+++++ mariadb restart +++++#
# Shutdown mariadb to restart with new config
mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown

# Restart mariadb with new config in the background to keep the container running
mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql'