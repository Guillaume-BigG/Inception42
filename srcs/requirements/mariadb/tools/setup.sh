#!/bin/bash
set -e

# Create the init SQL file
cat <<EOF > /init.sql
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Prepare the environment
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown mysql:mysql /init.sql

# Start MariaDB temporarily with grant tables enabled for init
mysqld --user=mysql --datadir=/var/lib/mysql --init-file=/init.sql &

# Wait for it to fully start (simple wait loop)
until mysqladmin ping --silent; do
    echo "Waiting for MariaDB to initialize..."
    sleep 2
done

# Kill the temporary mysqld after init
mysqladmin shutdown

# Start MariaDB normally
exec mysqld --user=mysql