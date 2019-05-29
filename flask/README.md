# Node ExpressJS example
Create a new directory for this example (or clone this repository with git clone https://github.com/danial-k/docker-intro.git):

mkdir -p docker-intro/node/app
cd docker-intro/node/app

# Setting up development container
Start a Node development container with:
```
docker run \
-it \
--name flask \
--hostname flask \
--mount type=bind,src=`pwd`,dst=/app \
--publish 3800:5000/tcp \
-w //app \
python:3.7 \
bash
```

Install flask using Python's package manager:
```
pip install flask
```

Create a new ```index.py``` file with the following content:
```
from flask import Flask
application = Flask(__name__)

@application.route("/")
def hello():
    return "Hello, World!"

if __name__ == "__main__":
    application.run(host='0.0.0.0')
```

To run the application with hot-reload enabled:
```
FLASK_DEBUG=1 FLASK_APP=index.py flask run -h 0.0.0.0
```

The application should then be available at http://127.0.0.1:3800.

## Building deployment container

To publish the application as a self-contained image, use the Dockerfile[Dockerfile] for this project (placed outside the ```app``` directory). This image will use the production-grade gunicorn WSGI server as opposed to the flask development server.

Create a WSGI entry point file ```wsgi.py```:
```
from index import application

if __name__ == "__main__":
    application.run()
```

```
docker build -t flask:1.0.0 .
```

This will send all files in the current directory to the Docker daemon's build context (excluding paths specified in [.dockerignore](.dockerignore)), then create and tag the image. Once the image has been built, run with:
```
docker run -p 3810:5000 flask:1.0.0
```
The application should then be available at http://127.0.0.1:3810
