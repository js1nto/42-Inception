#!/bin/sh

set -e 

echo "LANCEMENT DU SCRIPT DE CONFIGURATION MARIA DB"

mysqld_safe --datadir=/var/lib/mysql &

sleep 5

#if [ -z "$MARIADB_USER" ] || [ -z "$MARIADB_USER_PASSWORD" ] || [ -z "$MARIADB_ROOT_PASSWORD" ] || [ -z "$MARIADB_NAME" ]; then
#  echo "Erreur : Toutes les variables d'environnement (MARIADB_USER, MARIADB_USER_PASSWORD, MARIADB_ROOT_PASSWORD, MARIADB_NAME) doivent être définies."
#  exit 1
#fi

echo "FLUSH PRIVILEGES;" | mysql -u root

echo "DROP USER IF EXISTS '$MARIADB_USER'@'%';" | mysql -u root

echo "CREATE USER '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_USER_PASSWORD';" | mysql -u root

echo "GRANT ALL PRIVILEGES ON *.* TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_USER_PASSWORD';" | mysql -u root
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MARIADB_ROOT_PASSWORD';" | mysql -u root

echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MARIADB_ROOT_PASSWORD';" | mysql -u root

echo "CREATE DATABASE IF NOT EXISTS $MARIADB_NAME;" | mysql -u root

echo "FLUSH PRIVILEGES;" | mysql -u root

mysqladmin -u root shutdown

exec mysqld
