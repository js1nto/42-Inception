#!/bin/sh
cd /var/www/

if [ ! -f "/var/www/wp-config.php" ]; then
  # Create wp-config.php
  /usr/local/bin/wp config create \
    --dbname="${DB_NAME}" \
    --dbuser="${DB_USER}" \
    --dbpass="${DB_PASS}" \
    --dbhost="${DB_HOST}" \
    --force

  # Set direct file system method
  /usr/local/bin/wp config set FS_METHOD 'direct'

  # Install WordPress
  /usr/local/bin/wp core install \
    --url="https://${WP_HOST}" \
    --title="${WP_TITLE}" \
    --admin_user="${ADM_WP_NAME}" \
    --admin_password="${ADM_WP_PASS}" \
    --admin_email="${ADM_WP_EMAIL}"

  # Create an editor-level user
  /usr/local/bin/wp user create "${WP_USERNAME}" "${WP_USEREMAIL}" \
    --role="editor" \
    --user_pass="${WP_USERPASS}"

  # ✅ Create a read-only (subscriber) user
  /usr/local/bin/wp user create "${WP_READONLY_NAME}" "${WP_READONLY_EMAIL}" \
    --role="subscriber" \
    --user_pass="${WP_READONLY_PASS}"
fi

