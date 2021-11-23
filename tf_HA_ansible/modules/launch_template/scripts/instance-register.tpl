#!/usr/bin/env bash

sleep 5m

# Make a get request to control node in order to receive initial provisioning
instance_private_ip=$(hostname -I | awk '{print $1}')       # Save instance private ip to a bash variable

# To see which user is running the commands
whoami > /home/ubuntu/user.txt

# Let's save command in a sh file in order to see if variables are saved right
echo "curl -v http://${control_node_ip}:${control_node_port}/register/${server_type}?ip=$instance_private_ip > /home/ubuntu/log.txt" > /home/ubuntu/register.sh

# Then we execute register file
chmod +x /home/ubuntu/register.sh
cd /home/ubuntu/
./register.sh