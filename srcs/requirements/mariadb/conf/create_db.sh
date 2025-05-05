#!/bin/sh

set -e 

echo "LANCEMENT DU SCRIPT DE CONFIGURATION MARIA DB"

mysqld_safe --datadir=/var/lib/mysql &

sleep 5

if [ -z "$DB_USER" ] || [ -z "$DB_USERPASS" ] || [ -z "$DB_USERPASS" ] || [ -z "$DB_NAME" ]; then
  echo "Erreur : Toutes les variables d'environnement (DB_USER, DB_USERPASS, DB_NAME, MARIADB_NAME) doivent être définies."
  exit 1
fi

echo "FLUSH PRIVILEGES;" | mysql -u root

echo "DROP USER IF EXISTS '$DB_USER'@'%';" | mysql -u root

echo "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_USERPASS';" | mysql -u root

echo "GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_USERPASS';" | mysql -u root
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$DB_ROOT';" | mysql -u root

echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$DB_ROOT';" | mysql -u root

echo "CREATE DATABASE IF NOT EXISTS $DB_NAME;" | mysql -u root

echo "FLUSH PRIVILEGES;" | mysql -u root

mysqladmin -u root shutdown

exec mysqld
