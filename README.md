# Commands:

build image:<br/>
* docker-compose build<br/>

start server:<br/>
* docker-compose up -d<br/>

setup database:<br/>
* docker-compose run -d webapp rake db:setup

# Available methods:
|Path|Methods|
|---|---|
|accounts|GET POST|
|accounts/:id|GET PATCH DELETE|
|payments|GET POST|
|payments/:id|GET PATCH DELETE|
|branches|GET POST|
|payments/:id|GET|
