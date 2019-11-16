# Minimal React Docker example with build args
This project was created with ```npx create-react-app``` and demonstrates the use of Docker's ```build-args``` to replace placeholders with build-time variables.

The [Dockerfile](Dockerfile) for this project illustrates how to pass in for example, different API endpoints, as build configurtion parameters in a multistage Docker build.  Note that the ```ARG``` keyword must be redeclared after the ```FROM``` statement.

NodeJS' ```process.env.MY_ENV_VAR``` approach is taken and placeholders beginning with ```REACT_APP_``` are substituted per the create-react-app [documentation](https://create-react-app.dev/docs/adding-custom-environment-variables/).


## Deployment
To build docker image:
```shell
docker build \
--build-arg NODE_TAG=12 \
--build-arg NGINX_TAG=1.17.5 \
--build-arg API_URL=https://my-api.com \
-t my-react-app:0.0.1 .
```

To start Docker image:
```shell
docker run -p 8003:80 my-react-app:0.0.1
```

## Development
To start the development server (assuming node):
```shell
PORT=3200 REACT_APP_API_URL=http://127.0.0.1:3000 npm run start
```
Where ```PORT``` is the port for the development server, ```API_URL``` is the location of the backend.

## Building
This will create a production-optimised build output to the ```build``` directory.
```shell
REACT_APP_API_URL=http://127.0.0.1:3000 npm run build
```
