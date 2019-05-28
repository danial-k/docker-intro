# Java JSP Jetty Maven Docker example
Create a new directory for this example (or clone this repository with git clone https://github.com/danial-k/docker-intro.git):

mkdir -p docker-intro/maven/app
cd docker-intro/maven/app

# Setting up development container
Start a Maven development container with:
```
docker run \
-it \
--name maven \
--hostname maven \
--mount type=bind,src=`pwd`,dst=/app \
--publish 3600:8080/tcp \
-w //app \
maven:3.6-jdk-8 \
bash
```

Create an empty JSP application using Maven's Archetype generator:
```
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
```
mv app/* . && rm -rf app
```
The project source files should now be accessible to an IDE.  To run a Maven Jetty webserver, add the following to the project ```pom.xml``` under ```build.pluginManagement.plugins```:
```
...
<plugin>
  <groupId>org.eclipse.jetty</groupId>
  <artifactId>jetty-maven-plugin</artifactId>
  <version>9.2.21.v20170120</version>
</plugin>
...
```

Run the web project with the Maven Jetty plugin:
```
mvn jetty:run
```

The application should now be visible at http://127.0.0.1:3600.
