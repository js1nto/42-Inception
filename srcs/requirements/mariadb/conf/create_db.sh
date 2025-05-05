#!/bin/bash

# Check environment variables (optional but recommended)
#if [ -z "$DB_PASS" ] || [ -z "$DB_ROOT" ] || [ -z "$DB_NAME" ] || [ -z "$DB_USER2" ] || [ -z "$DB_PASS2" ]; then
#  echo "Error: Required environment variables (DB_PASS, DB_ROOT, DB_NAME, DB_USER2, DB_PASS2) are not set."
#  exit 1
#fi

# Initialize MySQL if not already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    chown -R mysql:mysql /var/lib/mysql
    mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm
fi

# Set up WordPress database and users if it doesn't exist
if [ ! -d "/var/lib/mysql/wordpress" ]; then

    cat << EOF > /tmp/create_db.sql
USE mysql;
FLUSH PRIVILEGES;

-- Clean up default/test users
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='wordpress_user';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

-- Set root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';

-- Create WordPress database
CREATE DATABASE ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';

CREATE USER '${READONLY_USER}'@'%' IDENTIFIED BY '${READONLY_PASS}';
GRANT SELECT ON \`${DB_NAME}\`.* TO '${READONLY_USER}'@'%';

FLUSH PRIVILEGES;
EOF

    # Run the SQL bootstrap
    /usr/bin/mysqld --user=mysql --bootstrap < /tmp/create_db.sql

    # Optional cleanup
    # rm -f /tmp/create_db.sql
fi
