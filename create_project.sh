#!/bin/bash

NAME="juless"
LOGIN="jsaintho"
DB_PW="1234"
DB_ROOT_PW="12345"
WP_USERPASS="123456"
ADM_WP_PASS="1234567"

rm -rf docker/overlay2/tubabzhuo2n8846rqcyzjkfs5/work/work
docker system prune --all --volumes

if [ ! -f ./srcs/.env ]; then
  touch ./srcs/.env
fi

truncate -s 0 ./srcs/.env

# --- MAKE ENV ---------------------------
echo "LOGIN=$LOGIN" >> ./srcs/.env
echo "DOMAIN_NAME=$LOGIN.42.fr" >> ./srcs/.env
echo "CERT_=./requirements/tools/$LOGIN.42.fr.crt" >> ./srcs/.env
echo "KEY_=./requirements/tools/$LOGIN.42.fr.key" >> ./srcs/.env
echo "DB_NAME=wordpress" >> ./srcs/.env
echo "DB_USER=wpuser" >> ./srcs/.env
echo "DB_HOST=mariadb" >> ./srcs/.env
echo "WP_TITLE=INCEPTION_$NAME" >> ./srcs/.env
echo "WP_USERNAME=$NAME" >> ./srcs/.env
echo "WP_USEREMAIL=$NAME@42.fr" >> ./srcs/.env
echo "WP_USERPASS=$NAME" >> ./srcs/.env
echo "WP_HOST=$NAME.42.fr" >> ./srcs/.env
echo "ADM_WP_NAME=$NAME" >> ./srcs/.env
echo "ADM_WP_EMAIL=$NAME@42.fr" >> ./srcs/.env

echo "DB_ROOT=$DB_ROOT_PW" >> srcs/.env
echo "WP_USERPASS=$WP_USERPASS" >> srcs/.env 
echo "DB_PASS=$DB_PW" >> srcs/.env
echo "ADM_WP_PASS=$ADM_WP_PASS" >> srcs/.env
# ------------------------------------------------
echo "✅ .env file created."


# --- SSL CERTIFICATE ---------------------------

CERT_FILE="./srcs/requirements/nginx/tools/${NAME}.42.fr.crt"
KEY_FILE="./srcs/requirements/nginx/tools/${NAME}.42.fr.key"
if [ ! -f ${CERT_FILE} ]; then
  touch ${CERT_FILE}
fi
if [ ! -f ${KEY_FILE} ]; then
  touch ${KEY_FILE}
fi

openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout "$KEY_FILE" \
  -out "$CERT_FILE" \
  -subj "/C=US/ST=State/L=City/O=Org/OU=IT/CN=${NAME}"

echo "✅ SSL certificate and key created:"
echo " - Certificate: $CERT_FILE"
echo " - Private Key: $KEY_FILE"
