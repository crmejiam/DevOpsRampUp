#!/usr/bin/env bash

# First, we update apt-get in order to get the latest versions of all dependencies
sudo apt-get update -y

# Let's install MySQL server
echo 'mysql-server mysql-server/root_password password ubuntu' | debconf-set-selections
echo 'mysql-server mysql-server/root_password_again password ubuntu' | debconf-set-selections
sudo apt install -y mysql-server

# Now we are going to log onto root user in MySQL, create the database movie_db, change the database
# to movie_db and execute table_creation_and_inserts.sql file to create all data required

# Let's download the .sql file directly from the repo
sudo curl -o table_creation_and_inserts.sql https://raw.githubusercontent.com/crmejiam/movie-analyst-api/master/data_model/table_creation_and_inserts.sql

mysql -u root -pubuntu << EOF
CREATE DATABASE movie_db; 
USE movie_db;
SOURCE /table_creation_and_inserts.sql;

CREATE USER 'backrampup'@'10.1.0.8' IDENTIFIED BY 'ubuntu';
GRANT ALL PRIVILEGES ON movie_db.* TO 'backrampup'@'10.1.0.8' WITH GRANT OPTION;
FLUSH PRIVILEGES;

EOF
# Line 22 to 24 is to authorize access to backend VM

# Let's define the required environment variables

echo "export BACK_HOST=${back_host}" >> /etc/profile

# We need to give access to backend VM to enter to the database VM
sudo sed -i 's/bind-address.*/bind-address            = 10.1.0.8/g' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i '32 i #skip-networking' /etc/mysql/mysql.conf.d/mysqld.cnf
# sudo service mysql restart