#!/bin/bash

#if [ -z "$DB_PASS" ] || [ -z "$DB_ROOT" ] || [ -z "$DB_NAME" ]; then
#  echo "Erreur : Toutes les variables d'environnement (DB_PASS, DB_ROOT, DB_NAME) doivent être définies."
#  exit 1
#fi

if [ ! -d "/var/lib/mysql/mysql" ]; then
    chown -R mysql:mysql /var/lib/mysql

    # init database
    mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm

    tfile=`mktemp`
    if [ ! -f "$tfile" ]; then
        return 1
    fi
fi

if [ ! -d "/var/lib/mysql/wordpress" ]; then

    cat << EOF > /tmp/create_db.sql
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='wordpress_user';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

-- Set root password
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${DB_ROOT}');

-- Create WordPress DB and main user
CREATE DATABASE ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;

-- Create non-admin WordPress user (subscriber)
USE ${DB_NAME};

-- Insert new WordPress subscriber user (using MD5 password)
INSERT INTO wp_users (user_login, user_pass, user_nicename, user_email, user_status, display_name)
VALUES ('comment_user', MD5('1234'), 'comment_user', 'comment_user@example.com', 0, 'comment_user');

-- Assign subscriber role to the new user
SET @user_id = LAST_INSERT_ID();

-- Insert the user's capabilities into wp_usermeta to give them the subscriber role
INSERT INTO wp_usermeta (user_id, meta_key, meta_value)
VALUES
(@user_id, 'wp_capabilities', 'a:1:{s:10:"subscriber";b:1;}'),
(@user_id, 'wp_user_level', '0');

EOF

    # Run the SQL script using MySQL bootstrap mode
    /usr/bin/mysqld --user=mysql --bootstrap < /tmp/create_db.sql

    # Optional: Clean up
    # rm -f /tmp/create_db.sql
fi
