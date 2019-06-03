# Java Drools Maven Docker example
[Drools](https://docs.jboss.org/drools/release/7.18.0.Final/drools-docs/html_single/) is an open source business rules management system (BRMS) designed to offload complex decision making from applications into a centrally managed rules repository. The suite includes Business Central, a web-based UI for authoring and managing rules and execution servers for providing REST endpoints to evaluate rules.
In this example, three containers will be used:
- a Maven container used to generate a Drools project
- a Business Central Workbench container used to manage the project and execution servers by acting as the controller
- a KIE Execution Server container to have rules pushed to it from Business Central and provide an API for running rules

# Building with Docker containers
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
Before this project can be imported into business central, a git master branch must be set up:

```shell
git init
git add src pom.xml
git config --global user.email "drools@example.com"
git config --global user.name "Drools"
git commit -m 'Initial commit'
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
--name kie-server \
--hostname kie-server \
--network drools \
--env KIE_SERVER_CONTROLLER=http://drools-workbench:8080/business-central/rest/controller \
--env KIE_SERVER_LOCATION=http://kie-server:8080/kie-server/services/rest/server \
--env KIE_SERVER_USER=admin \
--env KIE_SERVER_PWD=admin \
--env KIE_MAVEN_REPO=http://drools-workbench:8080/business-central/maven2 \
jboss/kie-server-showcase:7.18.0.Final
```
```KIE_SERVER_CONTROLLER``` is the path to the Business Central remote controller. ```KIE_SERVER_LOCATION``` is a self-identifying callback URL given to Business Central when it needs to make API calls back to this KIE container.```KIE_MAVEN_REPO``` is the remote Maven repository on Business Central used to retrieve built artifacts.

Revisiting http://127.0.0.1:3910/business-central/rest/controller/management/servers should show the new execution server.  In the Business Central workbench, visiting ```Menu``` > ```Deploy``` > ```Execution Servers``` should also show the new remote server.

The KIE execution server documentation will be available at http://127.0.0.1:3920/kie-server/docs.

## Importing project into Business Central
Navigate to the ```projects``` page and select ```Import Project```.  In the Repostitory URL, enter ```file:///app``` then select ```import```.  This will instruct the importer to read from the local container file system and import the project into its own local git repository. Select the project and choose ```OK``` to being the import process.  To view the project in the local Maven repository, navigate to ```Settings``` > ```Artifacts```.

## Making API requests
If using Postman, create a new collection and set basic auth options to ```admin``` and ```admin```.  In what follows, a number of requests will be made within this collection that will inherit authentication configuration information.
### Get server information
- Type: ```GET```
- URL: http://127.0.0.1:3920/kie-server/services/rest/server
- Headers: ```Accept```:```application/json```

### Get list of running KIE containers
A KIE container is an isolated rule execution environment (loaded kjar) to allow multiple API services (projects) to be served.  There is no relation between KIE containers and the underlying Docker container.
- Type: ```GET```
- URL: http://127.0.0.1:3920/kie-server/services/rest/server/containers
- Headers: ```Accept```:```application/json```

### Execute runtime commands
- Type: ```POST```
- URL: http://127.0.0.1:3920/kie-server/services/rest/server/containers/instances/app_1.0-SNAPSHOT
- Body type: ```raw```
- Content type: ```application/json```
- Headers: ```Accept```:```application/json```
- Body:
```
{
  "commands" : [ {
    "fire-all-rules": {
        "max": -1,
        "out-identifier": "firedActivations"
    }
  } ]
}
```
