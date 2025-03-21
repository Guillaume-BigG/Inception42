#the image set is the penultime stable version of debian
FROM 		debian:bullseye

#the args that are needed from the .env file
ARG			WORDPRESS_DB_HOST
ARG			WORDPRESS_DB_NAME
ARG			WORDPRESS_URL
ARG			WORDPRESS_GUEST_USER
ARG			WORDPRESS_GUEST_PASSWORD
ARG			WORDPRESS_DB_USER
ARG			WORDPRESS_DB_PASSWORD
ARG			WORDPRESS_ADMIN_USER
ARG			WORDPRESS_ADMIN_PASSWORD
ARG			WORDPRESS_ADMIN_EMAIL


#install all the needed programs for the wordpress to work (specially php and mariadb-client)
RUN			apt-get update && \
    		apt-get install -y \
    		php-fpm php-mysql \
    		mariadb-client \
    		wget && \
    		mkdir /run/php && \
    		rm -rf /var/lib/apt/lists/*

#set php-fm to listen through port 9000
COPY		conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

#download wp-cli and moves it to a folder inside the container
RUN			wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar  \
			&& chmod +x wp-cli.phar \
			&& mv wp-cli.phar /usr/local/bin/wp

# Set the working directory
WORKDIR /var/www/html/wordpress

# Copy the WordPress setup script
COPY tools/auto_config.sh .
RUN chmod 755 auto_config.sh

# Expose PHP-FPM port
EXPOSE 9000

# Set entrypoint to run the WordPress setup script
ENTRYPOINT ["sh", "auto_config.sh"]






# This is a Dockerfile for setting up a WordPress container with necessary dependencies, 
# including PHP, MariaDB client, and wp-cli.

# The base image is the penultimate stable version of Debian (Bullseye).
FROM debian:bullseye  # Using the 'bullseye' version of Debian as the base image.

# Declare the arguments needed for WordPress configuration (values are passed from the .env file).
ARG WORDPRESS_DB_HOST  # The host where the WordPress database is located.
ARG WORDPRESS_DB_NAME  # The name of the WordPress database.
ARG WORDPRESS_URL  # The URL of the WordPress site.
ARG WORDPRESS_GUEST_USER  # The guest user to be created in WordPress.
ARG WORDPRESS_GUEST_PASSWORD  # The password for the guest user.
ARG WORDPRESS_DB_USER  # The username for the database connection.
ARG WORDPRESS_DB_PASSWORD  # The password for the database user.
ARG WORDPRESS_ADMIN_USER  # The WordPress admin username.
ARG WORDPRESS_ADMIN_PASSWORD  # The WordPress admin password.
ARG WORDPRESS_ADMIN_EMAIL  # The email address for the WordPress admin user.

# Update package list, install necessary packages, and configure the environment.
RUN apt-get update && \  # Update package lists to make sure we install the latest versions.
    apt-get install -y \  # Install packages without requiring confirmation.
    php-fpm php-mysql \  # Install PHP-FPM (FastCGI Process Manager) and PHP MySQL extension for database support.
    mariadb-client \  # Install MariaDB client for database interaction.
    wget && \  # Install wget to download other necessary tools like wp-cli.
    mkdir /run/php && \  # Create the directory for PHP runtime.
    rm -rf /var/lib/apt/lists/*  # Clean up apt cache to reduce image size.

# Copy the PHP-FPM pool configuration file to the container, setting up PHP-FPM to listen on port 9000.
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf  # Configure PHP-FPM to listen on port 9000.

# Download and install wp-cli, a command-line tool for WordPress.
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar  \  # Download the wp-cli phar file.
    && chmod +x wp-cli.phar \  # Make the wp-cli file executable.
    && mv wp-cli.phar /usr/local/bin/wp  # Move wp-cli to a directory in the PATH for easy execution.

# Set the working directory inside the container to the WordPress directory.
WORKDIR /var/www/html/wordpress  # Define the working directory where WordPress will be installed.

# Copy the WordPress setup script (auto_config.sh) into the container.
COPY tools/auto_config.sh .  # Copy the auto_config.sh script into the container.
RUN chmod 755 auto_config.sh  # Make the auto_config.sh script executable.

# Expose port 9000 to allow communication with PHP-FPM from outside the container.
EXPOSE 9000  # Expose port 9000 for PHP-FPM to handle incoming requests.

# Set the entrypoint to the auto_config.sh script to run the WordPress setup process.
ENTRYPOINT ["sh", "auto_config.sh"]  # The container will run the auto_config.sh script when started.
