from flask import Flask

app = Flask(__name__)

# init image folder path
app.config['IMAGE_FOLDER'] = 'images/'
app.config['IMDB_FOLDER'] = 'imdbs/'


from webserver import views
