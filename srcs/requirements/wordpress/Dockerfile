FROM debian:buster


RUN apt update -y 

RUN apt install php-fpm php-mysql -y

RUN apt install curl -y


COPY ./script.sh /
COPY ./wp-config.php /


CMD [ "/script.sh" ]