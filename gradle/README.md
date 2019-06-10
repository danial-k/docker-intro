# C++ Gradle gcc Docker example
Clone this repository with ```git clone https://github.com/danial-k/docker-intro.git``` and open ```docker-intro/gradle``` in an ide.

Alternatively, to skip cloning and use these instructions directly, create a new directory for this example:
```shell
mkdir -p docker-intro/gradle
cd docker-intro/gradle
```

Create a Gradle container to generate a new project:
```shell
docker run \
-it \
--name gradle \
--hostname gradle \
--mount type=bind,src=`pwd`/app,dst=/app \
-w //app \
gradle:5.4-jdk \
bash
```

Initialise a new C++ project with Gradle and accept the default project name (```app```):
```shell
gradle init --type cpp-application --dsl groovy
```
At this point, the project source files should be visible in the ```app``` folder in your IDE, the application entrypoint is located at ```app/src/main/cpp/app.cpp```.

In a separate terminal window, create a new gcc container to compile the project:
```shell
docker run \
-it \
--name gcc \
--hostname gcc \
--mount type=bind,src=`pwd`/app,dst=/app \
-w //app \
gcc:9.1 \
bash
```

This container does not contain a Java runtime (required by gradle), install with:
```shell
apt-get update
apt-get install openjdk-8-jre -y
```

In the gcc container build the application:
```shell
./gradlew build
```

Verify the output:
```shell
./build/exe/main/debug/app
```
Although the application is functional, the current state is not optimised for production because of the added build tooling. To view the modifications to the original base image, in a new terminal window run ```docker diff gcc```.  The following section will deploy the compiled application to run on a suitable base image.

# Building deployment container
To publish the application as a self-contained image with a Debian base image, use the [Dockerfile](Dockerfile) for this project (placed outside the ```app``` directory):
```shell
docker build -t gradle-gcc:1.0.0 .
```

This will send all files in the current directory to the Docker daemon's build context (excluding paths specified in [.dockerignore](.dockerignore)), then create and tag the image. Note that the build context is ~ 350 KB with the specified exlusions, without which the context would increase to ~ 900 KB.  Once the image has been built, run with:
```shell
docker run gradle-gcc:1.0.0
```
The built application should then execute and terminate, followed by container shut down.
