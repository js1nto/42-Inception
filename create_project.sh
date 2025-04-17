#!/bin/bash

NAME="juless"
LOGIN="jsaintho"
DB_PW="1234"
DB_ROOT_PW="12345"
WP_USERPASS="123456"
ADM_WP_PASS="1234567"

echo "secrets" > project/.gitignore

touch project/secrets/credentials.txt
echo "LOGIN=$LOGIN" > project/secrets/credentials.txt
echo "DOMAIN_NAME=$LOGIN.42.fr" > project/secrets/credentials.txt
echo "CERT_=./requirements/tools/$LOGIN.42.fr.crt" >> project/secrets/credentials.txt
echo "KEY_=./requirements/tools/$LOGIN.42.fr.key" >> project/secrets/credentials.txt
echo "DB_NAME=wordpress" >> project/secrets/credentials.txt
echo "DB_USER=wpuser" >> project/secrets/credentials.txt
echo "DB_HOST=mariadb" >> project/secrets/credentials.txt
echo "WP_TITLE=INCEPTION_$NAME" >> project/secrets/credentials.txt
echo "WP_USERNAME=$NAME" >> project/secrets/credentials.txt
echo "WP_USEREMAIL=$NAME@42.fr" >> project/secrets/credentials.txt
echo "WP_USERPASS=$NAME" >> project/secrets/credentials.txt
echo "WP_HOST=$LOGIN.42.fr" >> project/secrets/credentials.txt
echo "ADM_WP_NAME=$NAME" >> project/secrets/credentials.txt
echo "ADM_WP_EMAIL=$NAME@42.fr" >> project/secrets/credentials.txt

echo $DB_PW > project/secrets/db_password.txt
echo $DB_ROOT_PW > project/secrets/db_root_password.txt
echo $WP_USERPASS > project/secrets/wp_password.txt
echo $ADM_WP_PASS > project/secrets/adm_wp_password.txt

echo '#!/bin/bash

cp secrets/credentials.txt srcs/.env

DB_PASSWORD_FILE=$(cat "secrets/db_root_password.txt")
echo "DB_ROOT=$DB_PASSWORD_FILE" >> srcs/.env

DB_PASSWORD_FILE=$(cat "secrets/wp_password.txt")
echo "WP_USERPASS=$DB_PASSWORD_FILE" >> srcs/.env 

DB_PASSWORD_FILE=$(cat "secrets/db_password.txt")
echo "DB_PASS=$DB_PASSWORD_FILE" >> srcs/.env

DB_PASSWORD_FILE=$(cat "secrets/adm_wp_password.txt")
echo "ADM_WP_PASS=$DB_PASSWORD_FILE" >> srcs/.env' > project/make_env.sh

chmod +x project/make_env.sh

echo '#!/bin/bash

mkcert -key-file srcs/requirements/nginx/tools/${USER}.42.fr.key -cert-file srcs/requirements/nginx/tools/${USER}.42.fr.crt https://${USER}.42.fr

chmod 777 srcs/requirements/nginx/tools/${USER}.42.fr.key srcs/requirements/nginx/tools/${USER}.42.fr.crt' > project/make_certs.sh

chmod +x project/make_certs.sh
