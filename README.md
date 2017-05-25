# Commands:

build image:<br/>
* docker-compose build<br/>

start server:<br/>
* docker-compose up -d<br/>

setup database:<br/>
* docker-compose run rest_app rails db:setup
* docker-compose run web rails db:setup

# Available methods:
|Path|Methods|
|---|---|
|/accounts|GET POST|
|/accounts/:id|GET PATCH DELETE|
|/accounts/:id/convert|PATCH|
|/payments|GET POST|
|/payments/:id|GET PATCH DELETE|
|/branches|GET POST|
|/branches/:id|GET|
