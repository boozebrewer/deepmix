from app import app
from flask import send_file, request, jsonify
import os
import uuid

from contextlib import redirect_stdout
from subprocess import call


def generate_new_imdb(data):
    if not os.path.exists(app.config['IMDB_FOLDER']):
        os.makedirs(app.config['IMDB_FOLDER'])
    unique_id = str(uuid.uuid4())[0:8]
    dir_to_make = os.path.join(app.config['IMDB_FOLDER'], unique_id)
    os.makedirs(dir_to_make)
    return unique_id


def run_style_transfer():
    with open('algo_out/pystdout.txt', 'w') as f:
        with redirect_stdout(f):
            print('it now prints to `help.txt`')
            call("python test/test2.py > algo_out/algo_stdout.txt", shell=True)
    return jsonify(status='ok')


@app.route('/')
@app.route('/index')
def index():
    print('hellooooo')
    return "SSSSS"


@app.route('/api/1/stdout')
def get_stdout():
    return send_file('../algo_out/algo_stdout.txt')


@app.route('/api/1/upload/<string:type>', methods=['POST'])
def save_pngs(type):
    file = request.files['file']
    path = 'images/' + type + '.png'
    print('server wd: ' + os.getcwd())
    file.save(path)
    return jsonify(status='ok')


@app.route('/api/1/start')
def start():
    out = run_style_transfer()
    return out


@app.route('/api/1/output')
def get_image():
    print('curr dir: ', os.getcwd())
    return send_file('../test/3.png')



