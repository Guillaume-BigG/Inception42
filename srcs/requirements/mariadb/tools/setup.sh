#!/bin/bash
set -e


cat <<EOF > /init.sql
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF


mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown mysql:mysql /init.sql


mysqld --user=mysql --datadir=/var/lib/mysql --init-file=/init.sql &


until mysqladmin ping --silent; do
    echo "Waiting for MariaDB to initialize..."
    sleep 2
done


mysqladmin shutdown


exec mysqld --user=mysql