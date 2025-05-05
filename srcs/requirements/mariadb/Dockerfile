FROM alpine:3.20.2

RUN apt-get update && apt install -y mariadb-server

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY tools/mariadb.sh /scripts/

RUN chmod +x /scripts/mariadb.sh

EXPOSE 3306

ENTRYPOINT [ "/scripts/mariadb.sh" ]
