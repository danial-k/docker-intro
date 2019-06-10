# Java JSP Jetty Maven Docker example
Clone this repository with ```git clone https://github.com/danial-k/docker-intro.git``` and open ```docker-intro/maven``` in an ide.

Alternatively, to skip cloning and use these instructions directly, create a new directory for this example:

```shell
mkdir -p docker-intro/maven
cd docker-intro/maven
```

# Setting up development container
Start a Maven development container with:
```shell
docker run \
-it \
--name maven \
--hostname maven \
--mount type=bind,src=`pwd`/app,dst=/app \
--publish 3010:8080/tcp \
-w //app \
maven:3.6-jdk-8 \
bash
```

Create an empty JSP application using Maven's Archetype generator:
```shell
mvn archetype:generate \
-DarchetypeGroupId=org.apache.maven.archetypes \
-DarchetypeArtifactId=maven-archetype-webapp \
-DarchetypeVersion=1.4 \
-DinteractiveMode=false \
-DgroupId=com.example \
-DartifactId=app \
-Dversion=1.0-SNAPSHOT
```

Move the contents of the generated project to the parent directory and remove the empty directory:
```shell
mv app/* . && rm -rf app
```
The project source files should now be accessible to an IDE (e.g. ```app/src/main/webapp/index.jsp```).  To run a Maven Jetty webserver, add the following to the project ```pom.xml``` under ```build.pluginManagement.plugins```:
```xml
...
<plugin>
  <groupId>org.eclipse.jetty</groupId>
  <artifactId>jetty-maven-plugin</artifactId>
  <version>9.2.21.v20170120</version>
</plugin>
...
```

Run the web project with the Maven Jetty plugin:
```shell
mvn jetty:run
```

The application should now be visible at http://127.0.0.1:3010.

Although the application is now functional, it is running on a development-focused base image (~500 MB).  In production, this would run on an optimised Jetty base image (~260 MB) per the following section.

## Building deployment container
To publish the application as a self-contained image, we will use a multi-stage build process (see the Dockerfile[Dockerfile] for this project (place in the maven directory). This Dockerfile will first build the source (using on the Maven image) and then produce a deployable image (based on the Jetty image):
```shell
docker build -t jsp-maven:1.0.0 .
```

This will send all files in the current directory to the Docker daemon's build context (excluding paths specified in [.dockerignore](.dockerignore)), then create and tag the image. With the ```target``` folder excluded, the build context is approximately 15KB, whereas without this exlusion the context increases to 30 KB. Once the image has been built, run with:
```shell
docker run -p 3011:8080 jsp-maven:1.0.0
```
The application should now be visible at http://127.0.0.1:3011/app.
