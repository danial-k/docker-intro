# Introduction
Swagger Codegen is a command-line utility to generate server API stubs and client SDKs from OpenAPI specification files.
This project generates Server stubs and client SDKs from OpenAPI v3 documents using Swagger Generator CLI 3.
As of writing, the official [swaggerapi/swagger-generator-cli](https://hub.docker.com/r/swaggerapi/swagger-codegen-cli) Docker images only support v2.x of the CLI.

# Building Docker image
Assuming you have cloned this repository and changed to this directory, run: 
```shell
docker build -t swagger-codegen-cli:3.0.11 .
```

# Interacting with the CLI
## Viewing available languages
To view the list of available languages (see next section for list) execute the ```langs``` command against using a temporary container (self-removed with ```--rm```):

```shell
docker run --rm \
swagger-codegen-cli:3.0.11 \
langs
```
## Generating Server/Client projects
Two paths should be (bind) mounted to the Docker image:
1. The OpenAPI Specification file as the input source
2. The output directory on the host into which the project will be generated

Assuming you are in directory that has both an ```openapi.json``` file and a directory titled ```output```, the following command will generate the project using the specification file.
Replace ```<YOUR_LANG_HERE>``` with one of the available languages/framweworks (see next section), e.g. ```spring```.
Note that ```//``` allows running on Docker for Windows and Linux/MacOS.
```shell
docker run --rm \
--mount type=bind,src=`pwd`/openapi.json,dst=/openapi.json \
--mount type=bind,src=`pwd`/output,dst=/output \
swagger-codegen-cli:3.0.11 \
generate \
-l <YOUR_LANG_HERE> \
-o //output/<YOUR_LANG_HERE> \
-i //openapi.json
```

## Overriding the default entrypoint
When the container starts, the default entrypoint executes the codegen java executable.  To enter an interactive shell instead, use:
```shell
docker run -it --rm \
--entrypoint="//bin/sh" \
--mount type=bind,src=`pwd`/openapi.yaml,dst=/openapi.yaml \
--mount type=bind,src=`pwd`/output,dst=/output \
swagger-codegen-cli:3.0.11
```

# Available languages/frameworks
- aspnetcore
- csharp
- csharp-dotnet2
- dynamic-html
- html
- html2
- java
- jaxrs-cxf-client
- jaxrs-cxf
- inflector
- jaxrs-cxf-cdi
- jaxrs-spec
- jaxrs-jersey
- jaxrs-di
- jaxrs-resteasy-eap
- jaxrs-resteasy
- spring
- nodejs-server
- openapi
- openapi-yaml
- kotlin-client
- kotlin-server
- php
- python
- python-flask
- scala
- scala-akka-http-server
- swift3
- swift4
- typescript-angular
