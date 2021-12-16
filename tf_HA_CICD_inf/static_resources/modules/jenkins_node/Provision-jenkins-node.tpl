#!/usr/bin/env bash

cd /home/ubuntu

apt-get update >> log.txt
apt-get install --yes ca-certificates curl gnupg lsb-release >> log.txt
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg >> log.txt
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null >> log.txt
apt-get update >> log.txt
apt-get install --yes docker-ce docker-ce-cli containerd.io >> log.txt

docker pull jenkins/jenkins
docker run -dp 8080:8080 --name jenkins jenkins/jenkins