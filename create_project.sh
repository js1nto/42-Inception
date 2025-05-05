#!/bin/bash

NAME="juless"
LOGIN="jsaintho"
DB_PW="1234"
DB_ROOT_PW="12345"
WP_USERPASS="123456"
ADM_WP_PASS="1234567"
READONLY_USER="pnjpnj"
READONLY_MAIL="pnj@yahoo.fr"
READONLY_PASS="12121212"

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
echo "PHP_VERSION=8.0" >> ./srcs/.env
echo "DB_ROOT=$DB_ROOT_PW" >> srcs/.env
echo "WP_USERPASS=$WP_USERPASS" >> srcs/.env 
echo "DB_PASS=$DB_PW" >> srcs/.env
echo "ADM_WP_PASS=$ADM_WP_PASS" >> srcs/.env
echo "READONLY_USER=$READONLY_USER" >> srcs/.env
echo "READONLY_USER=$READONLY_PASS" >> srcs/.env
# Get the current user using whoami
USER_NAME=$(whoami)
# Write the USER_NAME to the .env file
echo "USER=$USER_NAME" >> srcs/.env

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

# su -
# echo "127.0.0.1  juless.42.fr" >> /etc/hosts


# Wait for WordPress to finish setting up (e.g., wp-config.php to exist)
#until wp core is-installed --path=/var/www/html; do
#    sleep 5
#done

# Create non-admin WordPress user if not exists
#if ! wp user get "$READONLY_USER" --path=/var/www/html > /dev/null 2>&1; then
#    wp user create "$READONLY_USER" "$READONLY_MAIL" --user_pass="$READONLY_PASS" --role=subscriber --path=/var/www/html
#fi

#exec "$@"


echo "✅ SSL certificate and key created:"
echo " - Certificate: $CERT_FILE"
echo " - Private Key: $KEY_FILE"
