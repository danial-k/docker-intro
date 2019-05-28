# Introduction to Docker for development
This repository contains tutorials for developing with the following language/environments:
- [C# .net core](dotnetcore)

Each subdirectory in this project contains a Dockerfile for building a docker image after following each example.

## Developing in Docker
In the following, you will need to:
- In the event of port conflicts, use different ports to those specified in the examples.
- If using git bash for windows (MINIGW64), you may need to use ```//``` instead of ```/``` in the workdir parameter (```-w```) and prefix docker commands with ```winpty```.
- If using Chrome and you received the error ```ERR_UNSAFE_PORT```, use a different port.
