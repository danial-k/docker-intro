# Java Drools Maven Docker example
[Drools](https://docs.jboss.org/drools/release/7.18.0.Final/drools-docs/html_single/) is an open source business rules management system (BRMS) designed to offload complex decision making from applications into a centrally managed rules repository.  The suite includes Business Central, a web-based UI for authoring and managing rules and execution servers for providing REST endpoints to evaluate rules. 
In this example, three containers will be used:
- a Maven container used to generate a Drools project
- a Business Central Workbench container used to manage the project and execution servers by acting as the controller
- a KIE Execution Server container to have rules pushed to it from Business Central and provide an API for running rules

To allow containers to refer to each other by hostnames, a new Docker network will be created.

## Creating a network
```shell
docker network create drools
```

## Setting up Maven development container
Create a new directory for this example (or clone this repository with git clone https://github.com/danial-k/docker-intro.git):

```shell
mkdir -p docker-intro/maven/app
cd docker-intro/maven/app
```

Start a Maven development container with:
```
docker run \
-it \
--name drools \
--hostname drools \
--network drools \
--mount type=bind,src=`pwd`,dst=/app \
--publish 3900:8080/tcp \
-w //app \
maven:3.6-jdk-8 \
bash
```

Create an empty Drools application using Maven's Archetype generator:
```shell
mvn archetype:generate \
-DarchetypeGroupId=org.kie \
-DarchetypeArtifactId=kie-drools-archetype \
-DarchetypeVersion=7.18.0.Final \
-DinteractiveMode=false \
-DgroupId=com.example \
-DartifactId=app \
-Dversion=1.0-SNAPSHOT
```

Move generated files in ```app/app``` up one directory:
```shell
mv app/* . && rm -rf app
```

At this point, it may be worthwhile exploring the contents of the example ```.java``` class and the corresponding ```.drl``` rule file. To verify that unit tests are successful, run:
```shell
mvn clean test
```

## Starting a Business Central Workbench container
Start a Business Central UI Docker container and mount the source files to a local directory in the container:
```shell
docker run \
-d \
-p 3910:8080 \
--name drools-workbench \
--hostname drools-workbench \
--network drools \
--mount type=bind,src=`pwd`,dst=/app \
jboss/drools-workbench-showcase:7.18.0.Final
```

Login with ```admin``` and ```admin``` at
http://127.0.0.1:3910/business-central.

The Controller API documentation is available at http://127.0.0.1:3910/business-central/docs.  To view a list of execution server instances, (currenly none) visit http://127.0.0.1:3910/business-central/rest/controller/management/servers.  Note that additional API endpoints for other operations are documented [here](https://docs.jboss.org/drools/release/7.18.0.Final/drools-docs/html_single/#knowledge-store-rest-api-endpoints-ref_decision-tables).

## Starting a KIE execution server Docker container
Start a new KIE execution server container with the following.  Note that by setting ```JAVA_OPTS```, the original env values set in the base image will be overwritted, hence must be specified again.
```shell
docker run \
-d \
-p 3920:8080 \
-p 3921:9990 \
--name kie-server \
--hostname kie-server \
--network drools \
--env KIE_SERVER_LOCATION=http://kie-server:8080/kie-server/services/rest/server \
--env KIE_SERVER_USER=admin \
--env KIE_SERVER_PWD=admin \
--env KIE_SERVER_CONTROLLER=http://drools-workbench:8080/business-central/rest/controller \
jboss/kie-server-showcase:7.18.0.Final
```

Revisiting http://127.0.0.1:3910/business-central/rest/controller/management/servers should show the new execution server.  In the Business Central workbench, visiting ```Menu``` > ```Deploy``` > ```Execution Servers``` should also show the new remote server.

## Importing project into Business Central
Before importing the project into business central, a git master branch must be set up.  In the Maven container (```drools```) run:
```shell
git init
git add src pom.xml
git config --global user.email "drools@example.com"
git config --global user.name "Drools"
git commit -m 'Initial commit'
```

To import the project into Business Central, navigate to the ```projects``` page and select ```Import Project```.  In the Repostitory URL, enter ```file:///app``` then select ```import```.  This will instruct the importer to read from the local container file system and import the project into its own local git repository. Select the project and choose ```OK``` to being the import process.  Once imported, the project must be build and installed into the local Maven M2 repository, then deployed to the execution server. Choose ```Build & Install``` from the secondary menu bar then choose ```deploy``` once complete.  Once deployed, the project should be visible against the execution server.
