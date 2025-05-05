#!/bin/sh

sleep 5

#/usr/local/bin/wp user create "${WP_USERNAME}" "${WP_USEREMAIL}" --role="editor" --user_pass="${WP_USERPASS}" --network
#/usr/local/bin/wp user create "${READONLY_USER}" "${READONLY_USER}@wer.com" --role="subscriber" --user_pass="${READONLY_PASS}"++
  
echo "[========WP INSTALLATION STARTED========]"
if [ ! -f "/var/www/html/wordpress/wp-config.php" ]; then
    echo "wp-config.php non trouvé. Initialisation de WordPress..."

    wp core download --allow-root

    wp core config \
        --dbhost="$DB_HOST" \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASS" \
        --allow-root
    
     if ! /usr/local/bin/wp core is-installed; then
      /usr/local/bin/wp core install \
        --url="https://${WP_HOST}" \
        --title="${WP_TITLE}" \
        --admin_user="${ADM_WP_NAME}" \
        --admin_password="${ADM_WP_PASS}" \
        --admin_email="${ADM_WP_EMAIL}"
    fi
    wp user create \
        "$WP_USER" \
        "$WP_USEREMAIL" \
        --user_pass="$WP_USERPASS" \
        --allow-root


	chmod -R 777 . && chown -R www-data:www-data .

    echo "WordPress initialisé avec succès."
else
    echo "wp-config.php trouve. Aucune action effectuée."
fi

sleep 5 

echo "The website is accessible."
exec php-fpm83 -F

