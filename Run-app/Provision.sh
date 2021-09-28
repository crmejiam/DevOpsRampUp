#!/usr/bin/env bash

# First, we update apt-get in order to get the latest versions of all dependencies
apt-get update -y

# let's install nodeJS in order to be able to install package.json dependencies
apt-get install nodejs -y
apt-get install npm -y

# Bypass https to be able to install app's dependencies without getting CERT_UNTRUSTED Error
npm config set strict-ssl false

# Download the repo's contents
apt-get install git -y
git clone https://github.com/juan-ruiz/movie-analyst-api.git
git clone https://github.com/juan-ruiz/movie-analyst-ui.git

# Now, we're going to install all dependencies and build the app

# For Movie-Analyst-Api Repo
cd movie-analyst-api
npm install -y

# For Movie-Analyst-ui Repo
cd ../movie-analyst-ui 
npm install -y
