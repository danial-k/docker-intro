# C# ASP .net core Docker example
Create a new directory for this example (or clone this repository with ```git clone https://github.com/danial-k/docker-intro.git```):
```shell
mkdir -p docker-intro/dotnetcore/app
cd docker-intro/dotnetcore/app
```

## Setting up development container
Create a running development container using the .net core SDK image, with the host app directory mounted to the container ```/app``` folder with multiple ports exposed:
```shell
docker run \
-it \
--name dotnetcore \
--hostname dotnetcore \
--mount type=bind,src=`pwd`,dst=/app \
--publish 3004:5000/tcp \
--publish 3005:80/tcp \
-w //app \
mcr.microsoft.com/dotnet/core/sdk:2.2 \
bash
```

To view the list of available project types:
```shell
dotnet new --help
```

In this example, we will create an ASP.net core MVC web app.  Create a new project with:
```shell
dotnet new mvc --no-restore --no-https
```
At this point you should be able to view the project source files in an IDE by browsing to the mounted path on the host (```docker-intro/dotnetcore/app```)  URL routes (```/``` and ```privacy```) should be visible in ```Controllers/HomeController.cs```.

Modify ```Properties/launchSettings.json``` and under the ```app``` object, replace ```localhost``` with ```0.0.0.0```, per the solution [here](https://stackoverflow.com/questions/51188774/docker-dotnet-watch-run-error-unable-to-bind-to-https-localhost5000-on-the-i), otherwise the container will be unreachable.  If you've already ```run```, Terminate the process with ```Ctrl+C```, make the change and re-run.

Build and run the project with hot-reload enabled:
```shell
dotnet watch run
```

The application should then be visible at http://127.0.0.1:3004.  You should be able to modify source code and see the changes immediately.

Although the application is functional, the current state is not suitable for production because of file watching, debugging tools and the [sdk](https://hub.docker.com/_/microsoft-dotnet-core-sdk/) base image (~1.7 GB).  To optimise the application, the following will connect a new terminal to the running container and output a production-optimised build of the app to a ```published``` folder that can be run on an [aspnet](https://hub.docker.com/_/microsoft-dotnet-core-aspnet/) image (~260 MB):

```
docker exec -it dotnetcore bash
dotnet publish -c Release -o published
```
To run the published build, execute:
```
dotnet published/app.dll
```
The production-optimised application should now be visible at http://127.0.0.1:3005.

## Building deployment container
To publish the application as a self-contained production-optimised image, we will use a multi-stage build process (see the [Dockerfile](Dockerfile) for this project (place in the ```dotnetcore``` directory).  This Dockerfile will first build the source (using the [sdk](https://hub.docker.com/_/microsoft-dotnet-core-sdk/) image) and then produce a deployable image (based on the [aspnet](https://hub.docker.com/_/microsoft-dotnet-core-aspnet/) image).

From the ```dotnetcore/app``` path, run:
```
docker build -t dotnetcore:1.0.0 .
```
This will send all files in the current directory to the Docker daemon's build context  (excluding paths specified in [.dockerignore](.dockerignore)), then create and tag the image.  Note that the build context is approximately 4 MB, however if the .dockerignore file is removed, this will increase to about 11 MB as build outputs during development will also be included.  It is desirable to minimise the payload sent to the build context.

Once the image has been built, run with:
```shell
docker run -p 3006:80 dotnetcore:1.0.0
```
The app should then be available at http://127.0.0.1:3006.
