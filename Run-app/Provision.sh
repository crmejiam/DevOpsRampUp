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
git clone https://github.com/crmejiam/movie-analyst-ui.git

# For Movie-Analyst-Api Repo
cd movie-analyst-api
npm install -y

# For Movie-Analyst-ui Repo
cd ../movie-analyst-ui 
npm install -y

# Let's start running the ui and api to see if it works correctly (UI runs on port 3030 and api on port 3000)
cd /home/vagrant/movie-analyst-ui
npm start &              # start for movie-analyst-ui

cd /home/vagrant/movie-analyst-api
npm start &              # start for movie-analyst-api