# Description: Nginx Dockerfile

# pull the base image
FROM debian:bookworm

# update and upgrade the system
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

# create the ssl directory
RUN mkdir -p /etc/nginx/ssl

# generate the ssl certificate
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=FR/ST=Paris/L=Paris/O=42/CN=vdeliere.42.fr"

# copy the nginx configuration file
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

# define the command to run when the container starts
CMD ["nginx", "-g", "daemon off;"]