# pull the base image
FROM debian:bookworm

# update and upgrade the system
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y curl php8.2-fpm php8.2-mysql mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# Créer les répertoires nécessaires
RUN mkdir -p /var/www/wordpress /run/php && \
    chown -R www-data:www-data /var/www/wordpress /run/php

# Configurer PHP-FPM pour écouter sur le port 9000
RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 0.0.0.0:9000|g' /etc/php/8.2/fpm/pool.d/www.conf && \
    sed -i 's|;clear_env = no|clear_env = no|g' /etc/php/8.2/fpm/pool.d/www.conf
# copy the wordpress config script to the root directory of the container
COPY ./conf/wp_conf.sh /wp_conf.sh

# change the permission of the script to make it executable
RUN chmod +x /wp_conf.sh

WORKDIR /var/www/wordpress

#define the entrypoint command to run when the container starts
ENTRYPOINT ["/wp_conf.sh"]