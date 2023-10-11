#!/bin/sh

echo "-> (MariaDB) Configuring MariaDB...";
if [ ! -d "/run/mysqld" ]; then
    echo "-> (MariaDB) Granting MariaDB daemon run permissions...";
    mkdir -p /run/mysqld;
    chown -R mysql:mysql /run/mysqld;
fi

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "-> (MariaDB) Installing MySQL Data Directory...";
    chown -R mysql:mysql /var/lib/mysql;
    mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=$WP_DB_USER;
    sed -i "s/\r//g ; s/WP_DB_NAME/$WP_DB_NAME/g ; s/WP_DB_PASS/$WP_DB_PASS/g ; s/WP_DB_USER/$WP_DB_USER/g ; s/WP_DB_ROOT_PASS/$WP_DB_ROOT_PASS/g" /usr/local/bin/mysql_setup.sql;
    echo "-> (MariaDB) Configuring MySQL...";
	echo "WP_DB_NAME" $WP_DB_NAME
	echo "WP_DB_PASS" $WP_DB_PASS
	echo "WP_DB_USER" $WP_DB_USER
	echo "WP_DB_BON_NOM" $WP_DB_ROOT_PASS

    /usr/bin/mysqld --bootstrap < /usr/local/bin/mysql_setup.sql;
    echo "-> (MariaDB) MySQL configuration done.";
fi
echo "-> (MariaDB) Allowing remote connections to MariaDB";
echo "-> (MariaDB) Starting MariaDB daemon on port 3306.";
exec "/usr/bin/mysqld" --console;