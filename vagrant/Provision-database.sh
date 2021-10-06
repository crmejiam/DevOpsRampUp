#!/usr/bin/env bash

# First, we update apt-get in order to get the latest versions of all dependencies
apt-get update -y

# Let's install MySQL server
echo 'mysql-server mysql-server/root_password password ubuntu' | debconf-set-selections
echo 'mysql-server mysql-server/root_password_again password ubuntu' | debconf-set-selections
apt install -y mysql-server

# Now we are going to log onto root user in MySQL, create the database movie_db, change the database
# to movie_db and execute table_creation_and_inserts.sql file to create all data required
mysql -u root -pubuntu << EOF
CREATE DATABASE movie_db; 
USE movie_db;
source /home/vagrant/shared/table_creation_and_inserts.sql;

GRANT ALL PRIVILEGES ON *.* TO 'root'@'10.0.0.8' IDENTIFIED BY 'ubuntu' WITH GRANT OPTION;

EOF

# Line 18 is to authorize access to backend VM

# We need to give access to backend VM to enter to the database VM
sed -i 's/bind-address.*/#bind-address           = 127.0.0.1/g' /etc/mysql/my.cnf
sed -i '48 i #skip-networking' /etc/mysql/my.cnf
service mysql restart