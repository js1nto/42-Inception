#!/bin/bash

NAME="jules"
LOGIN="jsaintho"
DB_PW="2601"
DB_ROOT_PW="<database_root_password>"
WP_USERPASS="<wordpress_user_password>"
ADM_WP_PASS="<wordpress_admin_password>"

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

echo $DB_PW > ./srcs/.env
echo $DB_ROOT_PW > ./srcs/.env
echo $WP_USERPASS > ./srcs/.env
echo $ADM_WP_PASS > ./srcs/.env


echo '#!/bin/bash

mkcert -key-file srcs/requirements/nginx/tools/${USER}.42.fr.key -cert-file srcs/requirements/nginx/tools/${USER}.42.fr.crt https://${USER}.42.fr

chmod 777 srcs/requirements/nginx/tools/${USER}.42.fr.key srcs/requirements/nginx/tools/${USER}.42.fr.crt' 

mkcert -key-file srcs/requirements/nginx/tools/${USER}.42.fr.key -cert-file srcs/requirements/nginx/tools/${USER}.42.fr.crt https://${USER}.42.fr

chmod 777 srcs/requirements/nginx/tools/${USER}.42.fr.key srcs/requirements/nginx/tools/${USER}.42.fr.crt
