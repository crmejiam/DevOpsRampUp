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

echo "export DB_HOST=${db_host}" >> /etc/profile
echo "export DB_USER=${db_user}" >> /etc/profile
echo "export DB_PASS=${db_pass}" >> /etc/profile


# For Movie-Analyst-Api Repo
cd movie-analyst-api
sudo npm install -y

# Let's install MySQL server
echo 'mysql-server mysql-server/root_password password ubuntu' | debconf-set-selections
echo 'mysql-server mysql-server/root_password_again password ubuntu' | debconf-set-selections
sudo apt install -y mysql-server

# Let's start running the api (Api runs on 10.0.0.8 IP for VAGRANT [on port 3000 for terraform and vagrant])
npm start &              # start for movie-analyst-api