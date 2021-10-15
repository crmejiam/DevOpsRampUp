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
git clone https://github.com/crmejiam/movie-analyst-ui.git

# Let's define the required environment variables

echo "export BACK_HOST=${back_host}" >> /etc/profile

# For Movie-Analyst-ui Repo
cd movie-analyst-ui 
sudo npm install -y

# Let's start running the ui (UI runs on port 3030)
npm start &              # start for movie-analyst-ui