#!/usr/bin/env bash

# First, we update apt-get in order to get the latest versions of all dependencies
apt-get update -y

# let's install npm and nodeJS in order to be able to install package.json dependencies
apt-get install npm -y

# Bypass https to be able to install app's dependencies without getting CERT_UNTRUSTED Error
npm config set strict-ssl false

# Let's install n helper to install the latest node stable version
npm install -g n
n stable 

# Download the repo's contents
apt-get install git -y
git clone https://github.com/crmejiam/movie-analyst-api.git

# For Movie-Analyst-Api Repo
cd movie-analyst-api
npm install -y

# Let's copy table_creation_and_inserts.sql file for the creation of the database
cp ./data_model/table_creation_and_inserts.sql /home/vagrant/shared/

# Let's install MySQL server
echo 'mysql-server mysql-server/root_password password ubuntu' | debconf-set-selections
echo 'mysql-server mysql-server/root_password_again password ubuntu' | debconf-set-selections
apt install -y mysql-server

# Let's start running the api (Api runs on 10.0.0.8 IP on port 3000)
npm start &              # start for movie-analyst-api