#!/bin/sh

WP_PATH="/var/www"

if [ ! -f "${WP_PATH}/wp-config.php" ]; then
  /usr/local/bin/wp --path=${WP_PATH} config create \
    --dbname="${DB_NAME}" \
    --dbuser="${DB_USER}" \
    --dbpass="${DB_PASS}" \
    --dbhost="${DB_HOST}" \
    --force

  /usr/local/bin/wp --path=${WP_PATH} config set FS_METHOD 'direct'

  /usr/local/bin/wp --path=${WP_PATH} core install \
    --url="https://${WP_HOST}" \
    --title="${WP_TITLE}" \
    --admin_user="${ADM_WP_NAME}" \
    --admin_password="${ADM_WP_PASS}" \
    --admin_email="${ADM_WP_EMAIL}" \
    --skip-email

  /usr/local/bin/wp --path=${WP_PATH} user create "${WP_USERNAME}" "${WP_USEREMAIL}" \
    --role="editor" \
    --user_pass="${WP_USERPASS}"

  /usr/local/bin/wp --path=${WP_PATH} user create "${READONLY_USER}" "${READONLY_USER}@example.com" \
    --user_pass="${READONLY_PASS}" \
    --role="subscriber"
fi
