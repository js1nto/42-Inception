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
DELETE FROM     mysql.user WHERE User='';
DELETE FROM     mysql.user WHERE User='wordpress_user';
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';
CREATE DATABASE ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '${DB_USER}'@'%' IDENTIFIED by '${DB_PASS}';
GRANT ALL PRIVILEGES ON wordpress.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
-- Create non-admin WordPress user (subscriber)
USE ${DB_NAME};

-- Define user credentials
SET @username = 'comment_user';
SET @password = MD5('user_password'); -- Replace with a secure password
SET @email = 'comment_user@example.com';

-- Insert into wp_users
INSERT INTO wp_users (user_login, user_pass, user_nicename, user_email, user_status, display_name)
VALUES (@username, @password, @username, @email, 0, @username);

-- Get the new user ID
SET @user_id = LAST_INSERT_ID();

-- Assign subscriber role
INSERT INTO wp_usermeta (user_id, meta_key, meta_value)
VALUES
(@user_id, 'wp_capabilities', 'a:1:{s:10:"subscriber";b:1;}'),
(@user_id, 'wp_user_level', '0');
EOF

    # Run the SQL script using MySQL bootstrap mode
    /usr/bin/mysqld --user=mysql --bootstrap < /tmp/create_db.sql

    # Optional: clean up
    # rm -f /tmp/create_db.sql
fi
