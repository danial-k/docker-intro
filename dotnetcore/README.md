# C# ASP .net core Docker example
Create a new directory for this example (or clone this repository with ```git clone https://github.com/danial-k/docker-intro.git```):
```
mkdir -p docker-intro/dotnetcore/app
cd docker-intro/dotnetcore/app
```

## Setting up development container
Create a running development container using the .net core SDK image, with the host app directory mounted to the container ```/app``` folder and a range of ports exposed:
```
docker run \
-it \
--name dotnetcore \
--hostname dotnetcore \
--mount type=bind,src=`pwd`,dst=/app \
--publish 3500-3505:5000-5005/tcp \
-w //app \
mcr.microsoft.com/dotnet/core/sdk:2.2 \
bash
```

To view the list of available project types:
```
dotnet new --help
```

In this example, we will create an ASP.net core MVC web app.  Create a new project with:
```
dotnet new mvc --no-restore --no-https
```
At this point you should be able to view the project source files in an IDE by browsing to the mounted path on the host (```docker-intro/dotnetcore/app```).   Modify ```Properties/launchSettings.json``` and replace ```localhost``` with ```0.0.0.0```, per the solution [here](https://stackoverflow.com/questions/51188774/docker-dotnet-watch-run-error-unable-to-bind-to-https-localhost5000-on-the-i), otherwise the container will be unreachable.  If you've already ```run```, Terminate the process with ```Ctrl+C```, make the change and re-run.

Build and run the project with hot-reload enabled:
```
dotnet watch run
```

The application should then be visible at http://127.0.0.1:3500.  You should be able to modify source code and see the changes immediately.

## Building deployment container
To publish the application as a self-contained image, we will use a multi-stage build process (see the Dockerfile[Dockerfile] for this project (place in the ```dotnetcore``` directory).  This Dockerfule will first build the source (using on the ```sdk``` image) and then produce a deployable image (based on the ```runtime``` image).

From the ```dotnetcore/app``` path, run:
```
docker build -t dotnetcore:1.0.0 .
```
This will send all files in the current directory to the Docker daemon's build context, then create and tag the image.  Once the image has been built, run with:
```
docker run -p 3510:80 dotnetcore:1.0.0
```
The app should then be available at http://127.0.0.1:3510.
