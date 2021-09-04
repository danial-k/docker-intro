# Introduction to Docker for development
This repository contains guides for developing minimal starter apps in the following language/environments:
- [Python Flask](flask)
- [C# ASP .net core](dotnetcore)
- [Java JSP Maven](maven)
- [Java Thorntail Maven](thorntail)
- [Express NodeJS](node)
- [C++ Gradle gcc](gradle)
- [Wildfly application server](wildfly)
- [React](react)
- [django](django)

Each subdirectory in this project contains a Dockerfile for building a docker image after following each example.

## Developing in Docker
For the examples:
- In the event of port conflicts, use different ports to those specified in the examples.
- If using git bash for windows (MINIGW64), you may need to use ```//``` instead of ```/``` in the workdir parameter (```-w```) and prefix docker commands with ```winpty```.
- If using Chrome and you received the error ```ERR_UNSAFE_PORT```, use a different port.
