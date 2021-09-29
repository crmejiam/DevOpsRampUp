#!/usr/bin/env bash

# First, we update apt-get in order to get the latest versions of all dependencies
apt-get update -y

# Let's install MySQL server
apt-get install mysql-server -y

# Now we need to create movie_db database
mysql 
CREATE DATABASE movie_db 

# We need to execute the .sql file on movie-analyst-api repo
source /home/vagrant/shared/table_creation_and_inserts.sql

# [TEST] to see if DB was created correctly
SELECT * FROM movie_db