FROM alpine:3.20.2

RUN apt-get update && apt install -y mariadb-server

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY conf/create_db.sh /scripts/

RUN chmod +x /scripts/create_db.sh

EXPOSE 3306

ENTRYPOINT [ "/scripts/create_db.sh" ]
