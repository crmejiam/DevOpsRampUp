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
EOF