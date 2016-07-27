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

def upload_image(url, filename, imgtype):
    ''' upload '''
    # type is 'content' or 'style'
    url = "{}/upload/{}".format(url, imgtype)
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

def run_test():
    print('working dir: ' + os.getcwd())
    # upload content
    out2 = upload_image(BASE_URL, 'test/1.png', 'style')
    out3 = upload_image(BASE_URL, 'test/2.png', 'content')
    print('upload: ' + 'style ' + str(out2) + ' content ' + str(out3))
    # start algo
    out4 = start(BASE_URL)
    print('algo: ' + str(out4))
    # get std
    out5 = get_stdout(BASE_URL, 'client/std.txt')
    print('std: ' + str(out5))
    # get output
    result_path = 'client/result.png'
    out6 = download_image(BASE_URL, result_path)
    im = Image.open(result_path).show()
    print('result: ' + str(out6))
    print('done')


@click.command()
@click.option('--url', default=BASE_URL)
@click.option('--path', default='')
@click.option('--imgtype', default='')
@click.option('--do', type=click.Choice(['upload', 'start', 'std', 'result', 'testing']), default='testing')
def main(do, path, imgtype, url):
    BASE_URL = url
    if do == 'testing':
        run_test()
    elif do == 'upload':
        out3 = upload_image(BASE_URL, path, imgtype)
        print(imgtype + str(out3))
    elif do == 'start':
        out4 = start(BASE_URL)
        print('algo: ' + str(out4))
    elif do == 'std':
        out5 = get_stdout(BASE_URL, 'client/std.txt')
        print('std: ' + str(out5))
    elif do == 'result':
        result_path = 'client/result.png'
        out6 = download_image(BASE_URL, result_path)
        print('result: ' + str(out6))
    else:
        raise Exception()


if __name__ == '__main__':
    main()
