# Java Thorntail Maven Docker example
Clone this repository with ```git clone https://github.com/danial-k/docker-intro.git``` and open ```docker-intro/thorntail``` in an IDE.

Alternatively, to skip cloning and use these instructions directly, create a new directory for this example:
```shell
mkdir -p docker-intro/thorntail
cd docker-intro/thorntail
```

# Setting up a development container
Create and connect to a Maven container:
```shell
docker run \
-it \
--name thorntail \
--hostname thorntail \
--mount type=bind,src=`pwd`/app,dst=/app \
--publish 3015:8080/tcp \
-w //app \
maven:3.6-jdk-8 \
bash
```

If you've cloned this project and just want to see the build process, you may skip to _Run the application with the Maven thorntail plugin_.  Otherwise, create a ```pom.xml``` file in the ```app``` directory, with the same content as the [pom.xml](app/pom.xml) from this repository.

Create the source directory:
```shell
mkdir -p src/main/java/com/example/thorntail
```

In this directory create ```RestApplication.java```, defining ```/rest``` as the root API path, with the following content:
```java
package com.example.thorntail;

import javax.ws.rs.core.Application;
import javax.ws.rs.ApplicationPath;

@ApplicationPath("/rest")
public class RestApplication extends Application {
}
```

Then create ```HelloWorldEndpoint.java``` with the following content, defining the ```/rest/hello``` endpoint

```java
package com.example.thorntail;

import javax.ws.rs.Path;
import javax.ws.rs.core.Response;
import javax.ws.rs.GET;
import javax.ws.rs.Produces;

@Path("/hello")
public class HelloWorldEndpoint {

  @GET
  @Produces("text/plain")
  public Response doGet() {
    return Response.ok("Hello World!").build();
  }
}
```

Run the application with the Maven thorntail plugin:
```shell
mvn thorntail:run
```

The running application should be visible at http://127.0.0.1:3015/rest/hello.  Although the application is functioning, it is not production optimised because of the base Maven image it is running on.  For release, the application will be packaged as an uberjar (all dependecies bundled) and run as a regular ```java -jar``` process on a JRE base image.

## Building deployment container
To publish the application as a self-contained image, we will use a multi-stage build process (see the [Dockerfile](Dockerfile) for this project. This Dockerfile will first build the source (using on the Maven image) and then produce a deployable image (based on the OpenJDK JRE image):
```shell
docker build -t thorntail:1.0.0 .
```

This will send all files in the current directory to the Docker daemon's build context (excluding paths specified in [.dockerignore](.dockerignore)), then create and tag the image. With the exclusions specified, the build context is approximately 15KB, without which, it is approximately 80MB.  Once the image has been built, run with:
```shell
docker run -p 3016:8080 thorntail:1.0.0
```
The application should now be visible at http://127.0.0.1:3016/rest/hello.
