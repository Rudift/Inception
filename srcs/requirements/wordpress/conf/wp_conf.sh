#!/bin/bash

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
        --dbname=$MYSQL_DB \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb:3306 \
        --allow-root
    
    # Installer WordPress
    wp core install \
        --url=https://$DOMAIN_NAME \
        --title="$WP_TITLE" \
        --admin_user=$WP_ADMIN_N \
        --admin_password=$WP_ADMIN_P \
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