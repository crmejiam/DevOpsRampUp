# This file should be called app.py on flask project directory

from flask import Flask, request, Response
import os

app = Flask(__name__)
# <id> allows us to capture corresponding characters from the URL

@app.route("/register/<server_type>")
def instance_provision(server_type):
    # Copy public ssh key to created instance
    os.system('echo "yes\n" | sudo ssh-copy-id -f -i /root/.ssh/id_rsa.pub -o "IdentityFile /home/ubuntu/{}" ubuntu@{}'.format("cmm-rampup-key-ansible.pem", request.args.get("ip")))
    # Call provision playbook
    os.system('ansible-playbook -i {}, /home/ubuntu/ansible/register.yml --extra-vars "server_type={}"'.format(request.args.get("ip"), server_type))
    return Response(status=200)

@app.route("/update/<server_type>")
def instance_update(server_type):
    # Call provision playbook
    os.system('ansible-playbook /home/ubuntu/ansible/update.yml -i /home/ubuntu/ansible/inventory.asg_aws_ec2.yml --extra-vars "server_type={}"'.format(server_type))
    return Response(status=200)