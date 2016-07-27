from flask import Flask

app = Flask(__name__)
from app import views

# init image folder path
app.config['IMAGE_FOLDER'] = 'images/'
app.config['IMDB_FOLDER'] = 'imdbs/'


from app import views