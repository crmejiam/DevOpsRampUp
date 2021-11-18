# This file should be called app.py on flask project directory

from flask import Flask, request, Response
import os

app = Flask(__name__)
# <id> allows us to capture corresponding characters from the URL

@app.route("/register/<server_type>")
def instance_provision(server_type):
    # Copy public ssh key to created instance
    os.system('ssh-copy-id -f -i /home/ubuntu/.ssh/id_rsa.pub -o "IdentityFile /home/ubuntu/Ramp-Up-cristian.mejiam-Key-Pair.pem" ubuntu@{}'.format(request.args.get("ip")))
    # Call provision playbook
    os.system('ansible-playbook -i {}, ~/ansible/register.yml --extra-vars "server_type={}"'.format(request.args.get("ip"), server_type))
    return Response(status=200)