# ExpressJS Node example
Create a new directory for this example (or clone this repository with git clone https://github.com/danial-k/docker-intro.git):

mkdir -p docker-intro/node/app
cd docker-intro/node/app

# Setting up development container
Start a Node development container with:
```
docker run \
-it \
--name node \
--hostname node \
--mount type=bind,src=`pwd`,dst=/app \
--publish 3700:3000/tcp \
-w //app \
node:12.3 \
bash
```

Install nodemon globally to enable hot-reloading:
```
npm install -g nodemon
```
Install the ExpressJS application generator globally:
```
npm install -g express-generator
```

Create a new express application in the current directory:
```
express
```

Edit ```package.json``` and replace ```node ./bin/www``` in ```scripts.start``` with ```nodemon ./bin/www```.  This will use nodemon to monitor for file changes instead of node.  Note that on Windows hosts, ```--legacy-watch``` should be added (i.e. ```nodemon --legacy-watch ./bin/www```) because of a Windows file system [limitations](https://github.com/remy/nodemon#application-isnt-restarting).

To run the application with hot-reloading:
```
DEBUG=app:* npm start
```

The application should then be available at http://127.0.0.1:3700.

## Building deployment container

To publish the application as a self-contained image, we will use a multi-stage build process (see the Dockerfile[Dockerfile] for this project (place in the maven directory). This Dockerfule will first build the source (using on the Maven image) and then produce a deployable image (based on the Jetty image):
```
docker build -t express:1.0.0 .
```

This will send all files in the current directory to the Docker daemon's build context (excluding paths specified in [.dockerignore](.dockerignore)), then create and tag the image. Once the image has been built, run with:
```
docker run -p 3710:3000 express:1.0.0
```
The application should then be available at http://127.0.0.1:3710
