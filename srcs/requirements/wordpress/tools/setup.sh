#!/bin/bash

set -e

if [ ! -f /usr/local/bin/wp ]; then
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

chown -R www-data:www-data /var/www/html
cd /var/www/html

until mysqladmin ping -h"$MYSQL_HOST" --silent; do
    echo "Waiting for MariaDB..."
    sleep 2
done

if [ ! -f wp-config.php ]; then
    echo "Installing WordPress..."
    su www-data -s /bin/bash -c "
        wp core download --path=/var/www/html --allow-root;
        wp config create --dbname="${MYSQL_DATABASE}" --dbuser="${MYSQL_USER}" --dbpass="${MYSQL_PASSWORD}" --dbhost="${MYSQL_HOST}" --allow-root;
        wp core install --url="${DOMAIN_NAME}" --title="${WP_TITLE}" --admin_user="${WP_ADMIN_USER}" --admin_password="${WP_ADMIN_PASSWORD}" --admin_email="${WP_ADMIN_EMAIL}" --allow-root;
        wp user create "${WP_USER}" "${WP_USER_EMAIL}" --role=author --user_pass="${WP_USER_PASSWORD}" --allow-root;
    "
else
    echo "WordPress is already installed."
fi

exec php-fpm7.4 -R -F -d error_log=/dev/stderr