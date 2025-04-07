#!/bin/bash
#
# script is setting up a WordPress website using Docker and installing necessary components such as :
#       - the WP-CLI (WordPress Command Line Interface),
#       - configuring WordPress
#       - installing some plugins and themes.
#
# [ mkdir /var/www/, mkdir /var/www/html]
#       - creates the /var/www/ and /var/www/html directories. these will hold your WordPress files and content.
#       - this step ensures the correct folder structure for WordPress to be installed.
#
# [ curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar, 
#    chmod +x wp-cli.phar,
#    mv wp-cli.phar /usr/local/bin/wp
#  ] :
#       - downloads the wp-cli.phar file, which is the WordPress command-line tool (wp-cli).
#       - makes it executable with chmod +x.
#       - moves executable file to /usr/local/bin/wp, so it can be run globally with the wp command.
#
# [ mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php]
#       - renames sample WordPress configuration file (wp-config-sample.php) to wp-config.php.
#
# [ sed -i -r "s/db1/$db_name/1"   wp-config.php, sed -i -r "s/user/$db_user/1"  wp-config.php, sed -i -r "s/pwd/$db_pwd/1"    wp-config.php] :
#       - use sed (stream editor) to replace placeholders in wp-config.php file with actual database credentials ($db_name, $db_user, $db_pwd).
#       - this step configures WordPress to connect to the appropriate database.
#
# [ wp core install --url=$DOMAIN_NAME/ --title=$WP_TITLE --admin_user=$WP_ADMIN_USR --admin_password=$WP_ADMIN_PWD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root] :
#       - this command runs the wp-cli command to install WordPress with parameters:
#           --url=$DOMAIN_NAME/ sets the domain name (the website’s URL).
#           --title=$WP_TITLE sets site title.
#           --admin_user=$WP_ADMIN_USR sets WordPress admin username.
#           --admin_password=$WP_ADMIN_PWD sets WordPress admin password.
#           --admin_email=$WP_ADMIN_EMAIL sets admin email address.
#           --skip-email prevents WordPress from sending an email notification during installation.
#           --allow-root allows the command to be executed as root user.
#
# [ wp user create $WP_USR $WP_EMAIL --role=author --user_pass=$WP_PWD --allow-root ] :
#       - creates a new WordPress user ($WP_USR) with the role of author.
#       - new user is assigned a password ($WP_PWD), and an email address ($WP_EMAIL).
#  
# [ sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf, mkdir /run/php ] :
#       - sed command modifies PHP-FPM configuration to listen on port 9000 instead of default socket.
#       - mkdir /run/php creates necessary directory for PHP-FPM to store runtime information.
mkdir /var/www/
mkdir /var/www/html


cd /var/www/html
rm -rf *


curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 
chmod +x wp-cli.phar 
mv wp-cli.phar /usr/local/bin/wp


wp core download --allow-root

mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
mv /wp-config.php /var/www/html/wp-config.php


sed -i -r "s/db1/$db_name/1"   wp-config.php
sed -i -r "s/user/$db_user/1"  wp-config.php
sed -i -r "s/pwd/$db_pwd/1"    wp-config.php

wp core install --url=$DOMAIN_NAME/ --title=$WP_TITLE --admin_user=$WP_ADMIN_USR --admin_password=$WP_ADMIN_PWD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root
wp user create $WP_USR $WP_EMAIL --role=author --user_pass=$WP_PWD --allow-root
wp theme install astra --activate --allow-root


wp plugin update --all --allow-root

sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf

mkdir /run/php

/usr/sbin/php-fpm7.3 -F
