# nginx reverse proxy Docker Compose example
This example creates three nodes behind an nginx reverse proxy with path mapping.

## Start services
```shell
docker-compose up
```
The following endpoints should then be accessible:
- http://127.0.0.1:5000/whoami1
- http://127.0.0.1:5000/whoami2
- http://127.0.0.1:5000/whoami3

## Stop services
To bring down the stack, run:
```
docker-compose down
```
