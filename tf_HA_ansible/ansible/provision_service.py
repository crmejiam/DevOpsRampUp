# This file should be called app.py on flask project directory

from flask import Flask, request, Response
import os

app = Flask(__name__)
# <id> allows us to capture corresponding characters from the URL

@app.route("/register/<server_type>")
def instance_provision(server_type):
    os.system('ansible-playbook -i {}, ~/ansible/{}-register.yml'.format(request.args.get("ip"), server_type))
    return Response(status=200)