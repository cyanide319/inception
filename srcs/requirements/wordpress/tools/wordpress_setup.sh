#!/bin/bash

# Wait for the MariaDB container to be ready
# while ! mariadb -h$DB_HOST -u$WP_DB_USER -p$WP_DB_PASS $WP_DB_NAME &>/dev/null; do
#     echo "Waiting for the MariaDB container..."
#     sleep 5
# done

# 	chown -R www-data:www-data /var/www/*;
# 	chown -R 755 /var/www/*;
# 	mkdir -p /run/php/;
# 	touch /run/php/php7.3-fpm.pid;

# if [ ! -f /var/www/html/wp-config.php ]; then
# 	mkdir -p /var/www/html
# 	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar;
# 	chmod +x wp-cli.phar; 
# 	mv wp-cli.phar /usr/local/bin/wp;
# 	cd /var/www/html;
# 	wp core download --allow-root;
	
# 	# bouge mon fichier de configuration au bon endroit
# 	wp config create --dbname=$WP_DB_NAME --dbuser=$WP_DB_USER --dbpass=$WP_DB_PASS --dbhost=$MYSQL_HOST --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root
# 	wp core install --allow-root --url=${WP_URL} --title=${WP_TITLE} --admin_user=${WP_ADMIN_NAME} --admin_password=${WP_ADMIN_PASS} --admin_email=${WP_ADMIN_EMAIL}
# 	wp user create --allow-root ${WP_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSWORD};
# 	echo "Wordpress is ready!"
# else
# 	echo "Wordpress already exist"
#     fi

# exec "$@"

echo 'Wordpress Check MariaDB connection : '
echo "MYSQL_HOST : $DB_HOST"
echo "MYSQL_USER : $WP_DB_USER"
echo "MYSQL_PASSWORD : $WP_DB_PASS"
echo "MYSQL_DATABASE : $WP_DB_NAME"
while ! mariadb -h$WP_DB_HOST -u$WP_DB_USER -p$WP_DB_PASS $WP_DB_NAME --port=3306 &>/dev/null; do
    echo "Waiting for the MariaDB container..."
    sleep 3
done
echo 'Wordpress MariaDB connection SUCCESS !'

sudo adduser www-data -G www-data
mkdir -p /run/php
echo "Passed mkdir -p /run/php"
touch /run/php/php-fpm.pid
echo "Passed touch /run/php/php-fpm.pid"

echo "Checking if /var/www/html/wp-config.php is there ..."
if [ ! -f /var/www/html/wp-config.php ]; then

	echo "Attempt chown -R www-data:www-data /var/www/"
	sudo chown -R www-data:www-data /var/www/
	echo "Passed chown -R www-data:www-data /var/www/"
	sudo chmod -R 755 /var/www
	echo "Passed chown -R 755 /var/www"

	echo 'Wordpress START INSTALL !'
	mkdir -p /var/www/html
	echo "wget wordpress package ..."
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar;
	sudo chmod +x wp-cli.phar; 
	mv wp-cli.phar /usr/local/bin/wp;
	cd /var/www/html;

	if [ ! -f "./wp-activate.php" ]; then
		echo "wp core download ..."
		wp core download --allow-root;
	fi
	
	echo "wp create config with dbname $WP_DB_NAME ..."
	wp config create	\
		--allow-root				\
		--dbname=$WP_DB_NAME	\
		--dbuser=$WP_DB_USER		\
		--dbpass=$WP_DB_PASS	\
		--dbhost=$WP_DB_HOST		\
		--dbcharset="utf8"			\
		--dbcollate="utf8_general_ci"

	echo "wp core install for wordpress title $WP_TITLE ..."
	echo "WP_URL : $WP_URL"
	echo "WP_TITLE : $WP_TITLE"
	echo "WP_ADMIN_DB_USER : $WP_ADMIN_USER"
	echo "WP_ADMIN_DB_PASS : $WP_ADMIN_PASS"
	echo "WP_ADMIN_DB_EMAIL : $WP_ADMIN_EMAIL"
	if wp core install	\
		--allow-root	\
		--url=${WP_URL}	\
		--title=${WP_TITLE}	\
		--admin_user=${WP_ADMIN_USER}	\
		--admin_password=${WP_ADMIN_PASS}	\
		--admin_email=${WP_ADMIN_EMAIL};
	then
		echo "Wordpress core install SUCCESS !"
		echo "wp user create $WP_USER ..."
	else
		echo "Wordpress core install FAILED !"
		exit 1
	fi

	echo "WP_USER_DB_LOGIN: $WP_USER"
	echo "WP_USER_DB_EMAIL: $WP_USER_EMAIL"
	echo "WP_USER_DB_PASS: $WP_USER_PASS"
	if wp user create		\
		${WP_USER}	\
		${WP_USER_EMAIL}	\
		--role=author		\
		--allow-root		\
		--user_pass=${WP_USER_PASS}	\
		--porcelain;
	then 
		echo "WordPress user create SUCCESS !"
		echo "wp-config.php :"
		cat "/var/www/html/wp-config.php"
	else
		echo "WordPress user create FAILURE !"
		#exit 1
	fi 
	echo "Attempt chown -R www-data:www-data /var/www/"
	sudo chown -R www-data:www-data /var/www/*
	echo "Passed chown -R www-data:www-data /var/www/"
	sudo chmod -R 755 /var/www/*
	echo "Passed chown -R 755 /var/www"
	echo "Wordpress is ready!"
else
	echo "wp-config.php :"
	cat "/var/www/html/wp-config.php"
	echo "Attempt chown -R www-data:www-data /var/www/"
	sudo chown -R www-data:www-data /var/www/*
	echo "Passed chown -R www-data:www-data /var/www/"
	sudo chmod -R 755 /var/www/*
	echo "Passed chown -R 755 /var/www"
	echo "Wordpress already exist"
fi

exec "$@"