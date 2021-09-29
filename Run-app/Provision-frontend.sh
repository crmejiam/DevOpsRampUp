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
git clone https://github.com/crmejiam/movie-analyst-ui.git

# For Movie-Analyst-ui Repo
cd movie-analyst-ui 
npm install -y

# # Copy .env file to repo folder
# cp /home/vagrant/shared/.env /home/vagrant/movie-analyst-ui/v

# Let's start running the ui (UI runs on 10.0.0.10 IP on port 3030)
npm start &              # start for movie-analyst-ui