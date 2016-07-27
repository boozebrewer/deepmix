import requests
import click
import io
import os
import json
from PIL import Image


BASE_URL = 'http://127.0.0.1:5001/api/1'


def download_image(url, filename=None):
    ''' output '''
    ''' Downloads image from web server '''
    resp = requests.get(url + '/output')
    if not resp.ok:
        raise Exception(resp.reason)
    if filename is not None:
        with open(filename, "wb") as f:
            f.write(resp.content)
        return filename
    else:
        return io.BytesIO(resp.content)

def upload_image(filename, type):
    ''' upload '''
    # type is 'content' or 'style'
    url = "{}/upload/{}".format(BASE_URL, type)
    with open(filename, 'rb') as f:
        resp = requests.post(url, files={'file': f})
    if not resp.ok:
        raise Exception(resp.reason)
    return resp.json()


def get_stdout(url, filename=None):
    ''' stdout '''
    resp = requests.get(url + '/stdout')
    if filename is not None:
        with open(filename, "wb") as f:
            f.write(resp.content)
        return filename
    else:
        return resp.content

def start(url, filename=None):
    ''' start '''
    resp = requests.get(url + '/start')
    return resp.json()

# @click.command()
# @click.argument('dst', default='', type=click.Path(writable=True, dir_okay=False))
def main(dst=None):
    print('working dir: ' + os.getcwd())

    # upload content
    out2 = upload_image('test/1.png', type='style')
    out3 = upload_image('test/2.png', type='content')
    print('style ' + str(out2) + 'content ' + str(out3))
    # start algo
    out4 = start(BASE_URL)
    print('algo: ' + str(out4))
    # get std
    out5 = get_stdout(BASE_URL, 'client/std.txt')
    print('std: ' + str(out5))
    # get output
    result_path = 'client/result.png'
    out6 = download_image(BASE_URL, result_path)
    # im = Image.open(result_path).show()
    print('result: ' + str(out6))
    print('done')

if __name__ == '__main__':
    main()
