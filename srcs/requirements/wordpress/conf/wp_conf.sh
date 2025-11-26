#!/bin/bash

# Read the secrets from /run/secrets/
DB_USER=$(cat /run/secrets/db_user)
DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_USER=$(cat /run/secrets/wp_admin_user)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_PASSWORD)

# Attendre que MariaDB soit prêt
sleep 10

# Aller dans le répertoire WordPress
cd /var/www/wordpress

# Télécharger WP-CLI
if [ ! -f /usr/local/bin/wp ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Installer WordPress si pas déjà fait
if [ ! -f wp-config.php ]; then
    # Télécharger WordPress
    wp core download --allow-root
    
    # Créer la configuration
    wp config create \
        --dbname="${MYSQL_DB}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost=mariadb:3306 \
        --allow-root
    
    # Installer WordPress
    wp core install \
        --url="${DOMAIN_NAME}" \
        --title="$WP_TITLE" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email=$WP_ADMIN_E \
        --allow-root
    
    # Créer un utilisateur
    wp user create $WP_U_NAME $WP_U_EMAIL \
        --role=$WP_U_ROLE \
        --user_pass=$WP_U_PASS \
        --allow-root
fi

# Démarrer PHP-FPM
exec php-fpm8.2 -F -R