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

# Let's start running the api (Api runs on 10.0.0.8 IP on port 3000)
npm start &              # start for movie-analyst-api