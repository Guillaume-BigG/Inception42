#the image set is the penultime stable version of debian
FROM		debian:bullseye

#the args that are needed from the .env file
ARG			MYSQL_DATABASE
ARG			MYSQL_ROOT
ARG			MYSQL_ROOT_PASSWORD
ARG			MYSQL_USER
ARG			MYSQL_PASSWORD

# Update package lists
RUN 		apt update && apt install -y mariadb-server mariadb-client

#allow mysqld daemon to run, purge and recreate /var/lib/mysql with appropriate ownership
RUN 		mkdir -p /var/lib/mysql /var/run/mysqld && \
    		chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
    		chmod 755 /var/run/mysqld

# Replace the default configuration with our optimized config
COPY 		./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
RUN			chmod 644 /etc/mysql/mariadb.conf.d/50-server.cnf


# Copy setup script and set executable permissions
COPY tools/setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh


#exposes the 3306 port (default port for MariaDB)
EXPOSE		3306

# Start the setup script and MariaDB
ENTRYPOINT ["/tmp/setup.sh"]


#####################

# -------------------------------------
# ✅ Step 1: Select Base Image
# -------------------------------------

# Use Debian Bullseye as the base image (stable and secure)
FROM debian:bullseye

# -------------------------------------
# ✅ Step 2: Define Build-Time Variables (Passed from .env File)
# -------------------------------------

# These ARG variables allow us to pass database credentials from .env 
ARG MYSQL_DATABASE
ARG MYSQL_ROOT
ARG MYSQL_ROOT_PASSWORD
ARG MYSQL_USER
ARG MYSQL_PASSWORD

# -------------------------------------
# ✅ Step 3: Install MariaDB Server & Client
# -------------------------------------

# Update package lists and install MariaDB
RUN apt update && apt install -y mariadb-server mariadb-client

# -------------------------------------
# ✅ Step 4: Set Up MariaDB Directories & Permissions
# -------------------------------------

# Create necessary directories for MariaDB
# /var/lib/mysql → Stores all database data
# /var/run/mysqld → Stores the PID (process ID) file needed for MariaDB to run
RUN mkdir -p /var/lib/mysql /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
    chmod 755 /var/run/mysqld  # Secure directory permissions

# -------------------------------------
# ✅ Step 5: Copy Custom Configuration File
# -------------------------------------

# Replace default MariaDB settings with our optimized `50-server.cnf`
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

# Ensure the configuration file has correct permissions
RUN chmod 644 /etc/mysql/mariadb.conf.d/50-server.cnf

# -------------------------------------
# ✅ Step 6: Copy Setup Script & Grant Execution Permissions
# -------------------------------------

# Copy the database initialization script into the container
COPY tools/setup.sh /tmp/setup.sh

# Give execution permissions to setup.sh so it can run on startup
RUN chmod +x /tmp/setup.sh

# -------------------------------------
# ✅ Step 7: Expose the Database Port
# -------------------------------------

# MariaDB listens for connections on port 3306
EXPOSE 3306

# -------------------------------------
# ✅ Step 8: Define EntryPoint (Startup Command)
# -------------------------------------

# When the container starts, it runs `setup.sh`
# This script initializes the database and starts MariaDB properly
ENTRYPOINT ["/tmp/setup.sh"]
