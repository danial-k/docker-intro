Create a new directory for this example (or clone this repository with git clone https://github.com/danial-k/docker-intro.git):

mkdir -p docker-intro/thorntail/app cd docker-intro/thorntail/app

# Setting up a development container
Create and connect to a Maven container:
```
docker run \
-it \
--name thorntail \
--hostname thorntail \
--mount type=bind,src=`pwd`,dst=/app \
--publish 3800:8080/tcp \
-w //app \
maven:3.6-jdk-8 \
bash
```

Create a ```pom.xml``` file in the ```app``` directory, with the same content from this repository.

Create the source directory:
```
mkdir -p src/main/java/com/example/thorntail
```

In this directory create ```RestApplication.java```, defining ```/rest``` as the root API path, with the following content:
```
package com.example.thorntail;

import javax.ws.rs.core.Application;
import javax.ws.rs.ApplicationPath;

@ApplicationPath("/rest")
public class RestApplication extends Application {
}
```

Then create ```HelloWorldEndpoint.java``` with the following content, defining the ```/rest/hello``` endpoint

```
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
```
mvn thorntail:run
```

The running application should be visible at http://127.0.0.1:3800/rest/hello
