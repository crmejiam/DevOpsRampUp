#!/usr/bin/env bash

# First, we update apt-get in order to get the latest versions of all dependencies
sudo apt-get update -y

# let's install npm and nodeJS in order to be able to install package.json dependencies
sudo apt-get install npm -y

# Bypass https to be able to install app's dependencies without getting CERT_UNTRUSTED Error
sudo npm config set strict-ssl false

# Let's install n helper to install the latest node stable version
sudo npm install -g n
sudo n stable 

# Download the repo's contents
sudo apt-get install git -y
git clone https://github.com/crmejiam/movie-analyst-api.git

# Let's define the required environment variables

echo "DB_HOST=${db_host}" >> /movie-analyst-api/.env
echo "DB_USER=${db_user}" >> /movie-analyst-api/.env
echo "DB_PASS=${db_pass}" >> /movie-analyst-api/.env

# For Movie-Analyst-Api Repo
cd movie-analyst-api
sudo npm install -y

# Let's install MySQL server
echo 'mysql-server mysql-server/root_password password ubuntu' | debconf-set-selections
echo 'mysql-server mysql-server/root_password_again password ubuntu' | debconf-set-selections
sudo apt install -y mysql-server

# Now we're going to provision the database
mysql -h ${db_host} -u ${db_user} -p${db_pass} -Bse "CREATE DATABASE movie_db;USE movie_db;source /movie-analyst-api/data_model/table_creation_and_inserts.sql;"

# Let's start running the api (Api runs on 10.1.80.8 IP [on port 3000 for terraform and vagrant])
sudo npm start --verbose > /movie-analyst-api/back.log 2>&1 &   # start for movie-analyst-api
# with the previous command we save the npm start output on back.log file for debug purposes
