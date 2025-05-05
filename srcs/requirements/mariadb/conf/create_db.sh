#!/bin/sh

set -e

echo "LANCEMENT DU SCRIPT DE CONFIGURATION MARIA DB"

# Démarrage du serveur en arrière-plan
mysqld_safe --datadir=/var/lib/mysql &

# Pause pour laisser MariaDB démarrer
sleep 5

# ✅ Vérification des variables d'environnement
#if [ -z "$MARIADB_USER" ] || [ -z "$MARIADB_USER_PASSWORD" ] || [ -z "$MARIADB_ROOT_PASSWORD" ] || [ -z "$MARIADB_NAME" ]; then
#  echo "Erreur : Toutes les variables d'environnement (MARIADB_USER, MARIADB_USER_PASSWORD, MARIADB_ROOT_PASSWORD, MARIADB_NAME) doivent être définies."
#  exit 1
#fi

# 🔄 Attente que MariaDB soit prêt
until mariadb -u root -e "SELECT 1" > /dev/null 2>&1; do
  echo "Waiting for MariaDB to be ready..."
  sleep 2
done

# 🧹 Nettoyage éventuel d'utilisateur existant
echo "DROP USER IF EXISTS '$MARIADB_USER'@'%';" | mysql -u root

# 👤 Création de l'utilisateur de base
echo "CREATE USER '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_USER_PASSWORD';" | mysql -u root

# 👤 Création de l'utilisateur root distant si besoin
echo "CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '$MARIADB_ROOT_PASSWORD';" | mysql -u root

# 🛡️ Attribution des privilèges
echo "GRANT ALL PRIVILEGES ON *.* TO '$MARIADB_USER'@'%' WITH GRANT OPTION;" | mysql -u root
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;" | mysql -u root

# 🗃️ Création de la base de données
echo "CREATE DATABASE IF NOT EXISTS \`$MARIADB_NAME\`;" | mysql -u root

# 🔁 Appliquer les changements
echo "FLUSH PRIVILEGES;" | mysql -u root

# ⛔ Arrêt du serveur MariaDB en préparation du démarrage réel
mysqladmin -u root shutdown

# 🚀 Lancement final
exec mysqld
