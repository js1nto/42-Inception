FROM alpine:3.20.2

ARG MARIADB_USER
ARG MARIADB_USER_PASSWORD
ARG MARIADB_NAME
ARG MARIADB_ROOT_PASSWORD

ENV MARIADB_USER=$MARIADB_USER \
    MARIADB_USER_PASSWORD=$MARIADB_USER_PASSWORD \
    MARIADB_NAME=$MARIADB_NAME \
    MARIADB_ROOT_PASSWORD=$MARIADB_ROOT_PASSWORD

RUN export MARIADB_USER=$MARIADB_USER && \
    export MARIADB_USER_PASSWORD=$MARIADB_USER_PASSWORD && \
    export MARIADB_NAME=$MARIADB_NAME && \
    export MARIADB_ROOT_PASSWORD=$MARIADB_ROOT_PASSWORD && \
RUN apk update && apk add --no-cache mariadb mariadb-client

RUN mkdir /var/run/mysqld; \
    chmod 777 /var/run/mysqld; \
    { echo '[mysqld]'; \
      echo 'skip-host-cache'; \
      echo 'skip-name-resolve'; \
      echo 'bind-address=0.0.0.0'; \
    } | tee  /etc/my.cnf.d/docker.cnf; \
    sed -i "s|skip-networking|skip-networking=0|g" \
      /etc/my.cnf.d/mariadb-server.cnf

RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

EXPOSE 3306

COPY requirements/mariadb/conf/create_db.sh .
RUN sh create_db.sh && rm create_db.sh
#COPY create_db.sh /usr/local/bin/create_db.sh
#RUN chmod +x /usr/local/bin/create_db.sh

#ENTRYPOINT ["/usr/local/bin/create_db.sh"]
USER mysql
CMD ["/usr/bin/mysqld", "--skip-log-error"]
