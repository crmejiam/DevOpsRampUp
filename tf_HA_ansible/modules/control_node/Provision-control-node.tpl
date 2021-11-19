#!/usr/bin/env bash

# Let's create a public ssh key to access to managed nodes

echo | ssh-keygen -P ''

# We need to create a config file on .ssh folder in order to avoid authorization prompt

echo "StrictHostKeyChecking no" > /root/.ssh/config

# First we need to install ansible

sudo apt update
sudo apt install --yes software-properties-common 
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install --yes ansible

# Also, let's install mysql for db provisioning

sudo apt install --yes mysql-server

# Let's install git in order to get ansible's repo folder

sudo apt install --yes git

# Let's change directory to /home/ubuntu/ to do everything on ubuntu's home dir (just in case)

cd /home/ubuntu/

# Now we are going to clone the entire repo (because we can't download just a certain folder)

git clone https://github.com/crmejiam/DevOpsRampUp.git

# Let's move ansible folder to home and delete the rest 

sudo mv ./DevOpsRampUp/tf_HA_ansible/ansible/ /home/ubuntu
sudo rm -rf ./DevOpsRampUp

# We need to download .sql file in order to dump db entries later

curl -o ansible/table_creation_and_inserts.sql https://raw.githubusercontent.com/crmejiam/movie-analyst-api/master/data_model/table_creation_and_inserts.sql

# Let's create a folder to arrange provisioning service

mkdir provisioning_service

# Now we need to install python3, pip, flask and virtualenv in order to execute the provisioning service

sudo apt install --yes python3
sudo apt install --yes python3-pip
sudo pip install flask
sudo pip install virtualenv

# Let's activate our virtualenv 

virtualenv ./provisioning_service

# and pass the process code to virtualenv folder and rename file to app.py 

sudo mv ansible/provision_service.py provisioning_service/app.py

# Finally, let's run flask with virtualenv activated and on background

source provisioning_service/bin/activate
cd provisioning_service
flask run --host=0.0.0.0 --port=5000 > log.txt 2>&1       # run process on background