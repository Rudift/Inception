#!/bin/bash

# Read the secrets from /run/secrets/
DB_USER=$(cat /run/secrets/db_user)
DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_USER=$(cat /run/secrets/wp_admin_user)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)

# Wait for MariaDB to be ready
sleep 10

# Move to the wordpress directory
cd /var/www/wordpress

# Download WP-CLI
if [ ! -f /usr/local/bin/wp ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Install WordPress if not done already
if [ ! -f wp-config.php ]; then
    # Download WordPress
    wp core download --allow-root
    
    # Create the config
    wp config create \
        --dbname="${MYSQL_DB}" \
        --dbuser="${DB_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost=mariadb:3306 \
        --allow-root
    
    # Install WordPress
    wp core install \
        --url="${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root
    
    # User creation
    wp user create "${WP_U_NAME}" "${WP_U_EMAIL}" \
        --role="${WP_U_ROLE}" \
        --user_pass="${WP_U_PASS}" \
        --allow-root
fi

# Launch PHP-FPM
exec php-fpm8.2 -F -R