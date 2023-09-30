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
    mysql_install_db;
    sed -i "s/\r//g ; s/WP_DB_NAME/$WP_DB_NAME/g ; s/WP_DB_PASS/$WP_DB_PASS/g ; s/WP_DB_USER/$WP_DB_USER/g ; s/MYSQL_ROOT_PASSWORD/$MYSQL_ROOT_PASSWORD/g" /var/lib/mysql/mysql_setup.sql;
    echo "-> (MariaDB) Configuring MySQL...";

    /usr/bin/mysqld --bootstrap < /var/lib/mysql/mysql_setup.sql;
    echo "-> (MariaDB) MySQL configuration done.";
fi
echo "-> (MariaDB) Allowing remote connections to MariaDB";
echo "-> (MariaDB) Starting MariaDB daemon on port 3306.";
exec "/usr/bin/mysqld" --console;