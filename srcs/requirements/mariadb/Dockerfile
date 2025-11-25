# Description: MariaDB Dockerfile

# pull the base image
FROM debian:bookworm

# update and upgrade the systeme
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y mariadb-server netcat-openbsd && \
    rm -rf /var/lib/apt/lists/*

# copy file from host to container
COPY ./conf/mdb-conf.sh /mdb-conf.sh

# set permission to the file
RUN chmod +x /mdb-conf.sh

# define entrypoint command to run when the container starts
ENTRYPOINT [ "./mdb-conf.sh" ]