#!/bin/bash

set -e  # Exit immediately if any command fails

# Ensure MariaDB data directory is initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB in the background
mysqld_safe --skip-networking &
echo "Waiting for MariaDB to start..."
until mysqladmin ping -h localhost --silent; do
    sleep 2
done
echo "MariaDB started successfully."

# Secure MariaDB installation
mysql -u root <<EOF
DROP USER IF EXISTS ''@'localhost';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';

CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;

CREATE USER IF NOT EXISTS '$MYSQL_USER'@'wordpress' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'wordpress';

ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
EOF

echo "Database setup completed."

# Stop MariaDB and run as the main container process
mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown
exec mysqld_safe

###############################################

set -e  # Exit immediately if any command fails (prevents silent failures)

# -------------------------------------
# ✅ Step 1: Initialize the Database Directory (if empty)
# -------------------------------------

# MariaDB stores its internal tables in `/var/lib/mysql/mysql`
# If this folder is empty, it means MariaDB has never been initialized.
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    
    # `mysql_install_db` sets up the necessary database files for MariaDB
    # It ensures the database structure is created before starting the server.
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# -------------------------------------
# ✅ Step 2: Start MariaDB in the Background
# -------------------------------------

# `mysqld_safe` is a wrapper that starts the MariaDB server safely.
# `--skip-networking` ensures no external connections are allowed during setup.
mysqld_safe --skip-networking &

echo "Waiting for MariaDB to start..."
# `mysqladmin ping` checks if the database is ready.
# The loop waits until MariaDB is fully up before proceeding.
until mysqladmin ping -h localhost --silent; do
    sleep 2  # Wait 2 seconds before checking again
done
echo "MariaDB started successfully."

# -------------------------------------
# ✅ Step 3: Secure MariaDB & Create the WordPress Database
# -------------------------------------

# The following SQL commands are executed to set up the database
mysql -u root <<EOF

# Remove anonymous users (default MariaDB setup includes an insecure empty user)
DROP USER IF EXISTS ''@'localhost';

# Remove the default `test` database (MariaDB includes it by default)
DROP DATABASE IF EXISTS test;

# Ensure no remnants of the test database exist
DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';

# Create the WordPress database (if it doesn't exist already)
CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;

# Create a dedicated WordPress user (restricted to `wordpress` service)
# The password is provided via environment variables
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'wordpress' IDENTIFIED BY '$MYSQL_PASSWORD';

# Grant full privileges on the WordPress database to this user
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'wordpress';

# Secure the root user by setting a password (if not already set)
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';

# Apply all changes to ensure they take effect
FLUSH PRIVILEGES;
EOF

echo "Database setup completed."

# -------------------------------------
# ✅ Step 4: Shutdown Temporary Instance & Start MariaDB as Main Process
# -------------------------------------

# `mysqladmin shutdown` stops the temporary instance before launching MariaDB as the main process
mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

# `exec` ensures MariaDB runs as the primary process of the container
exec mysqld_safe
