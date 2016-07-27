from contextlib import redirect_stdout
from subprocess import call
import os

with open('../outputs/pystdout.txt', 'w') as f:
    with redirect_stdout(f):
        print('it now prints to `help.text`')
        path_to_write = ' '
        call("python test2.py > ../outputs/stdout.txt", shell=True)