#!/bin/bash

# Wait for the MariaDB container to be ready
while ! mariadb -h$DB_HOST -u$WP_DB_USER -p$WP_DB_PASS $WP_DB_NAME &>/dev/null; do
    echo "Waiting for the MariaDB container..."
    sleep 5
done

	chown -R www-data:www-data /var/www/*;
	chown -R 755 /var/www/*;
	mkdir -p /run/php/;
	touch /run/php/php7.3-fpm.pid;

if [ ! -f /var/www/html/wp-config.php ]; then
	mkdir -p /var/www/html
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar;
	chmod +x wp-cli.phar; 
	mv wp-cli.phar /usr/local/bin/wp;
	cd /var/www/html;
	wp core download --allow-root;
	
	# bouge mon fichier de configuration au bon endroit
	wp config create --dbname=$WP_DB_NAME --dbuser=$WP_DB_USER --dbpass=$WP_DB_PASS --dbhost=$MYSQL_HOST --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root
	wp core install --allow-root --url=${WP_URL} --title=${WP_TITLE} --admin_user=${WP_ADMIN_NAME} --admin_password=${WP_ADMIN_PASS} --admin_email=${WP_ADMIN_EMAIL}
	wp user create --allow-root ${WP_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSWORD};
	echo "Wordpress is ready!"
else
	echo "Wordpress already exist"
    fi

exec "$@"