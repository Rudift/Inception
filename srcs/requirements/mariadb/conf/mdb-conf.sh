#!/bin/bash

# Read the secrets from /run/secrets/
MYSQL_USER=$(cat /run/secrets/db_user)
MYSQL_PASSWORD=$(cat /run/secrets/db_user)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

# Create the socket directory
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld

# Init the database if necessary
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# Start the MariaDB server
mariadbd --user=mysql --skip-networking &
pid="$!"

# Waiting MariaDB to start
sleep 5

# Creating the base and the user
mariadb -u root << EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DB}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

# Stop the temporary process
kill "$pid"
wait "$pid"

# Start foreground MariaDB
exec mariadbd --user=mysql --bind-address=0.0.0.0