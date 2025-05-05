#!/bin/sh
cd /var/www/ 
if [ ! -f "/var/www/wp-config.php" ]; then
  # wp cli update
  /usr/local/bin/wp config create --dbname="${DB_NAME}" --dbuser="${DB_USER}" --dbpass="${DB_PASS}" --dbhost="${DB_HOST}" --force
  /usr/local/bin/wp config set FS_METHOD 'direct'
  
  /usr/local/bin/wp core install --url="https://${WP_HOST}" --title="${WP_TITLE}" --admin_user="${ADM_WP_NAME}" --admin_password="${ADM_WP_PASS}" --admin_email="${ADM_WP_EMAIL}"
  /usr/local/bin/wp user create "${WP_USERNAME}" "${WP_USEREMAIL}" --role="editor" --user_pass="${WP_USERPASS}"
  # Create additional WordPress user (read-only or other role)
  /usr/local/bin/wp user create "${READONLY_USER}" "${READONLY_USER}@example.com" \
    --user_pass="${READONLY_PASS}" --role="subscriber"
  wp user create newuser newuser@example.com --role=subscriber --user_pass=StrongPassword123
fi


