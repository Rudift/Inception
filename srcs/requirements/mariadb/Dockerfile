# Description: MariaDB Dockerfile

# pull the base image
FROM debian:bookworm

# update and upgrade the systeme
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# create the dir for the socket
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld

# copy file from host to container
COPY ./conf/mdb-conf.sh /mdb-conf.sh

# set permission to the file
RUN chmod +x /mdb-conf.sh

# define entrypoint command to run when the container starts
ENTRYPOINT [ "./mdb-conf.sh" ]