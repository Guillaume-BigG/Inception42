#!/bin/bash

set -e

# Create init script in proper location for MariaDB auto-execution
mkdir -p /docker-entrypoint-initdb.d
cat <<EOF > /docker-entrypoint-initdb.d/init.sql
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Prepare MariaDB runtime directory
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Start MariaDB in foreground (PID 1)
exec mysqld