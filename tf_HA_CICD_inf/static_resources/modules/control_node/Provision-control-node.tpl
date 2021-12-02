#!/usr/bin/env bash

# Let's create a public ssh key to access to managed nodes

echo | ssh-keygen -P ''

# We need to create a config file on .ssh folder in order to avoid authorization prompt

echo "StrictHostKeyChecking no" > /root/.ssh/config

# First we need to install ansible

apt update
apt install --yes software-properties-common 
add-apt-repository --yes --update ppa:ansible/ansible
apt install --yes ansible

# Also, let's install mysql for db provisioning

apt install --yes mysql-server

# Let's install git in order to get ansible's repo folder

apt install --yes git

# Let's install docker in order to be able to execute docker ansible playbooks
# [commands extracted from docker documentation]

apt-get update
apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install docker-ce docker-ce-cli containerd.io

# Let's change directory to /home/ubuntu/ to do everything on ubuntu's home dir (just in case)

cd /home/ubuntu/

# Now we are going to clone the entire repo (because we can't download just a certain folder)

git clone https://github.com/crmejiam/DevOpsRampUp.git

# Let's move ansible folder to home and delete the rest 

mv ./DevOpsRampUp/tf_HA_CICD_inf/static_resources/ansible/ /home/ubuntu
rm -rf ./DevOpsRampUp

# We need to download .sql file in order to dump db entries later

curl -o ansible/table_creation_and_inserts.sql https://raw.githubusercontent.com/crmejiam/movie-analyst-api/master/data_model/table_creation_and_inserts.sql

# Create key.pem file needed to ssh on managed nodes

echo "${key-pair}" > ./cmm-rampup-key-ansible.pem
chmod 700 ./cmm-rampup-key-ansible.pem                  # in order to avoid unprotected private key error

# Send environment variables to ansible vars file

echo "back_host: ${back_host}" >> ansible/roles/frontend/vars/main.yml

echo "db_host: ${rds_endpoint}" >> ansible/roles/backend/vars/main.yml
echo "db_user: ${db_user}" >> ansible/roles/backend/vars/main.yml
echo "db_pass: ${db_pass}" >> ansible/roles/backend/vars/main.yml

echo "db_host: ${rds_endpoint}" >> ansible/roles/database/vars/main.yml
echo "db_user: ${db_user}" >> ansible/roles/database/vars/main.yml
echo "db_pass: ${db_pass}" >> ansible/roles/database/vars/main.yml

# Now we need to install python3, pip, flask and virtualenv in order to execute the provisioning service

apt install --yes python3
apt install --yes python3-pip
pip install flask
pip install virtualenv
pip install PyMySQL
pip install docker

# Before we create the provisioning service let's provision the database

ansible-playbook /home/ubuntu/ansible/db_provision.yml

# Now let's create a folder to arrange the provisioning service

mkdir provisioning_service

# Let's activate our virtualenv 

virtualenv ./provisioning_service

# and pass the process code to virtualenv folder and rename file to app.py 

mv ansible/provision_service.py provisioning_service/app.py

# Finally, let's run flask with virtualenv activated and on background

source provisioning_service/bin/activate
cd provisioning_service
flask run --host=0.0.0.0 --port=5000 > log.txt 2>&1 &      # run process on background