USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY 'WP_DB_ROOT_PASS';
CREATE DATABASE WP_DB_NAME;
CREATE USER WP_DB_USER@'%' IDENTIFIED BY 'WP_DB_PASS';
GRANT ALL PRIVILEGES ON WP_DB_NAME.* TO WP_DB_USER@'%' IDENTIFIED BY 'WP_DB_PASS';
FLUSH PRIVILEGES;