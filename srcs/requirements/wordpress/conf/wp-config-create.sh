#!/bin/sh
cd /var/www/ 
if [ ! -f "/var/www/wp-config.php" ]; then
  # wp cli update
  /usr/local/bin/wp config create --dbname="${DB_NAME}" --dbuser="${DB_USER}" --dbpass="${DB_PASS}" --dbhost="${DB_HOST}" --force
  /usr/local/bin/wp config set FS_METHOD 'direct'
  
  /usr/local/bin/wp core install --url="https://${WP_HOST}" --title="${WP_TITLE}" --admin_user="${ADM_WP_NAME}" --admin_password="${ADM_WP_PASS}" --admin_email="${ADM_WP_EMAIL}"
  /usr/local/bin/wp user create "${WP_USERNAME}" "${WP_USEREMAIL}" --role="editor" --user_pass="${WP_USERPASS}"

  # Check for required environment variables
  if [[ -z "$READONLY_USER" || -z "$READONLY_PASS" ]]; then
    echo "Missing READONLY_USER or READONLY_PASS. Aborting."
    exit 1
  fi
  # Check if user already exists
  if /usr/local/bin/wp user get "$READONLY_USER" > /dev/null 2>&1; then
    echo "User '$READONLY_USER' already exists. Skipping creation."
  else
    echo "Creating WordPress user: $READONLY_USER"
    /usr/local/bin/wp user create "$READONLY_USER" "${READONLY_USER}@example.com" \
      --user_pass="$READONLY_PASS" --role="subscriber" || {
      echo "Failed to create user $READONLY_USER"
      exit 1
    }
  fi

fi


