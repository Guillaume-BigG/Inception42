#!/bin/sh

set -e  # Exit script if any command fails

if ! wp core is-installed --allow-root --path=/var/www/wordpress; then
    echo "Setting up WordPress..."
    chown -R www-data:www-data /var/www/html/wordpress
    wp core download --allow-root --path=/var/www/html/wordpress
    # Configure WordPress
    wp config create --allow-root \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --dbcharset="utf8"

    # Install WordPress
    wp core install --allow-root \
        --url="$WORDPRESS_URL" \
        --title="Inception" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
        --skip-email

    # Create Guest User
    wp user create --allow-root "$WORDPRESS_GUEST_USER" "$WORDPRESS_GUEST_EMAIL" \
        --role=author --user_pass="$WORDPRESS_GUEST_PASSWORD"

    # Install & Activate Theme + Plugins
    wp theme install oceanwp --activate --allow-root
    wp plugin update --all --allow-root

    echo "WordPress installation completed."
fi

# Ensure PHP-FPM is running in the foreground
exec php-fpm7.4 -F



# This script automates the installation and setup of WordPress in a Docker or server environment.

# Exit the script immediately if any command fails.
set -e  # Ensures that if any command fails, the script stops executing immediately.

# Check if WordPress is already installed by checking its core installation status.
if ! wp core is-installed --allow-root --path=/var/www/wordpress; then
    echo "Setting up WordPress..."  # Notify that the WordPress installation is starting.

    # Change the ownership of the WordPress directory to 'www-data' user and group.
    chown -R www-data:www-data /var/www/html/wordpress  # Make sure the web server has proper permissions.

    # Download the latest version of WordPress to the specified path.
    wp core download --allow-root --path=/var/www/html/wordpress  # Downloads WordPress files to the correct directory.

    # Configure the WordPress installation by creating the wp-config.php file.
    wp config create --allow-root         --dbname="$WORDPRESS_DB_NAME" \  # Database name
        --dbuser="$WORDPRESS_DB_USER" \  # Database user
        --dbpass="$WORDPRESS_DB_PASSWORD" \  # Database password
        --dbhost="$WORDPRESS_DB_HOST" \  # Database host (e.g., localhost or IP address)
        --dbcharset="utf8"  # Charset for the WordPress database (utf8 for general compatibility).

    # Install WordPress with provided site and admin details.
    wp core install --allow-root         --url="$WORDPRESS_URL" \  # The URL where WordPress will be accessible.
        --title="Inception" \  # The title of the WordPress site.
        --admin_user="$WORDPRESS_ADMIN_USER" \  # WordPress admin username.
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \  # WordPress admin password.
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \  # WordPress admin email.
        --skip-email  # Skip sending the email about the installation.

    # Create a guest user with the 'author' role.
    wp user create --allow-root "$WORDPRESS_GUEST_USER" "$WORDPRESS_GUEST_EMAIL"         --role=author --user_pass="$WORDPRESS_GUEST_PASSWORD"  # Creates a guest user with author privileges.

    # Install and activate the "OceanWP" theme and update all plugins.
    wp theme install oceanwp --activate --allow-root  # Installs and activates the OceanWP theme.
    wp plugin update --all --allow-root  # Updates all installed plugins to their latest versions.

    echo "WordPress installation completed."  # Notify that the installation process is completed.
fi

# Ensure that PHP-FPM runs in the foreground to keep the container or service active.
exec php-fpm7.4 -F  # Starts the PHP-FPM service in the foreground to keep the process running.
