# C++ Gradle gcc Docker example
Create a new directory for this example (or clone this repository with git clone https://github.com/danial-k/docker-intro.git):
```shell
mkdir -p docker-intro/node/app
cd docker-intro/node/app
```

Create a Gradle container to generate a new project:
```shell
docker run \
-it \
--name gradle \
--hostname gradle \
--mount type=bind,src=`pwd`,dst=/app \
-w //app \
gradle:5.4-jdk \
bash
```

Initialise a new C++ project with Gradle and accept the default project name (```app```):
```shell
gradle init --type cpp-application --dsl groovy
```

Create a new gcc container to compile the project:
```shell
docker run \
-it \
--name gcc \
--hostname gcc \
--mount type=bind,src=`pwd`,dst=/app \
-w //app \
gcc:9.1 \
bash
```

This container does not contain a Java runtime (required by gradle), install with:
```shell
apt-get update
apt-get install openjdk-8-jre
```

In the gcc container build the application:
```shell
./gradlew build
```

Verify the output:
```shell
./build/exe/main/debug/app
```

# Building deployment container
To publish the application as a self-contained image with a Debian base image, use the [Dockerfile](Dockerfile) for this project (placed outside the app directory):
```shell
docker build -t gradle-gcc:1.0.0 .
```

This will send all files in the current directory to the Docker daemon's build context (excluding paths specified in [.dockerignore](.dockerignore) ), then create and tag the image. Once the image has been built, run with:
```shell
docker run gradle-gcc:1.0.0
```
