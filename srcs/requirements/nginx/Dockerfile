# Description: Nginx Dockerfile

# pull the base image
FROM debian:bookworm

# update and upgrade the system
RUN apt-get update && apt-get upgrade -y

# # install the required packages
RUN apt-get install -y nginx openss1

# create the ssl directory
RUN mkdir -p /etc/nginx/ssl

# generate the ssl directory
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout \
    /etc/nginx/ssl/inception.key -subj "/C=FR/ST=Ile-de-France/L=Paris/O=42/OU=42/CN=vdeliere.42.fr/UID=vdeliere"

# copy the nginx configuration file
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# create the nginx configuration file
RUN mkdir -p /var/www/wordpress

# change the owner of the wordpress directory
RUN chown -R www-data:www-data /var/www/wordpress

# define the command to run when the container starts
CMD ["nginx", "-g", "daemon off;"]