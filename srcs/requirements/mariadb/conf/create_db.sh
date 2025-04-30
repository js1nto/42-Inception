#!/bin/bash

# Optional: Check required environment variables
# Uncomment if needed
# if [ -z "$DB_PASS" ] || [ -z "$DB_ROOT" ] || [ -z "$DB_NAME" ] || [ -z "$DB_USER" ]; then
#     echo "Erreur : Toutes les variables d'environnement (DB_PASS, DB_ROOT, DB_NAME, DB_USER) doivent être définies."
#     exit 1
# fi

if [ ! -d "/var/lib/mysql/mysql" ]; then
    chown -R mysql:mysql /var/lib/mysql

    # Initialize the MariaDB system database
    mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm

    tfile=$(mktemp)
    if [ ! -f "$tfile" ]; then
        echo "Erreur : impossible de créer un fichier temporaire."
        exit 1
    fi
fi

if [ ! -d "/var/lib/mysql/wordpress" ]; then

    cat << EOF > /tmp/create_db.sql
USE mysql;
FLUSH PRIVILEGES;

-- Clean up default users and test DB
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='wordpress_user';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

-- Set root password (MariaDB-compatible way)
# UPDATE mysql.user SET Password = PASSWORD('${DB_ROOT}') WHERE User = 'root' AND Host = 'localhost';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${DB_ROOT}');

-- Create WordPress DB and user
CREATE DATABASE ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;

-- Create non-admin WordPress user (subscriber)
USE ${DB_NAME};

-- Define user credentials
SET @username = 'user_';
SET @password = MD5('1234'); -- Replace with a secure password
SET @email = 'comment_user@example.com';

-- Insert user into wp_users
INSERT INTO wp_users (user_login, user_pass, user_nicename, user_email, user_status, display_name)
VALUES (@username, @password, @username, @email, 0, @username);

-- Get new user ID
SET @user_id = LAST_INSERT_ID();

-- Assign subscriber role
INSERT INTO wp_usermeta (user_id, meta_key, meta_value)
VALUES
(@user_id, 'wp_capabilities', 'a:1:{s:10:"subscriber";b:1;}'),
(@user_id, 'wp_user_level', '0');
EOF

    # Execute the SQL script in bootstrap mode
    /usr/bin/mysqld --user=mysql --bootstrap < /tmp/create_db.sql

    # Optional: Clean up
    # rm -f /tmp/create_db.sql
fi
