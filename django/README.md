# django app

## Local Development

### Direct
Install the expected version of python:
```shell
pyenv install
```

Install dependencies
```
pip install -r requirements.txt
```

Start development server:
```shell
python manage.py runserver 0:8000
```

App should be accessible at http://127.0.0.1:8000

### Docker
```shell
docker-compose up --build
```

The production app should be available at http://127.0.0.1:10111

The development app should be available at http://127.0.0.1:10112

To stop the containers, use `Ctrl + c`

To remove the containers and their data:
```
docker-compose down --remove-orphans
```

To develop inside the development app, connect to the container with
```
docker-compose exec app-dev bash
```

Start development server per local development instructions above
