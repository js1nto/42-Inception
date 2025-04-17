FROM debian:buster


RUN apt-get update -y && apt-get install mariadb-server -y

COPY ./50-server.cnf /etc/mysql/mariadb.conf.d/


COPY ./script.sh /


CMD ["/script.sh"]
