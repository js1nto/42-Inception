#!/bin/bash

NAME="juless"
LOGIN="jsaintho"
DB_PW="1234"
DB_ROOT_PW="12345"
WP_USERPASS="123456"
ADM_WP_PASS="1234567"

echo "secrets" > project/.gitignore

if [ ! -f ./srcs/.env ]; then
  touch ./srcs/.env

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
echo "WP_HOST=$LOGIN.42.fr" >> ./srcs/.env
echo "ADM_WP_NAME=$NAME" >> ./srcs/.env
echo "ADM_WP_EMAIL=$NAME@42.fr" >> ./srcs/.env

echo "DB_ROOT=$DB_ROOT_PW" >> srcs/.env
echo "WP_USERPASS=$WP_USERPASS" >> srcs/.env 
echo "DB_PASS=$DB_PW" >> srcs/.env
echo "ADM_WP_PASS=$ADM_WP_PASS" >> srcs/.env
# ------------------------------------------------



# --- SSL CERTIFICATE ---------------------------

mkcert -key-file srcs/requirements/nginx/tools/${USER}.42.fr.key -cert-file srcs/requirements/nginx/tools/${USER}.42.fr.crt https://${USER}.42.fr

chmod 777 srcs/requirements/nginx/tools/${USER}.42.fr.key srcs/requirements/nginx/tools/${USER}.42.fr.crt
# ------------------------------------------------
