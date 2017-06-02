# Commands:

build image:<br/>
* docker-compose build<br/>

start server:<br/>
* docker-compose up -d<br/>

setup database:<br/>
* docker-compose run rest_app bin/rails db:setup RAILS_ENV=development
* docker-compose run web bin/rails db:setup RAILS_ENV=development

# Available methods:
|Path|Methods|
|---|---|
|/accounts|GET POST|
|/accounts/:id|GET PATCH DELETE|
|/accounts/:id/convert|PATCH|
|/payments|GET POST|
|/payments/:id|GET PATCH DELETE|
|/payments/carry|PATCH|
|/branches|GET POST|
|/branches/:id|GET|
|/users|POST|
|/users/login|POST|

# Register in:
/users (POST)
examples:<br/>
{ "user" : { "username" : "admin", "password" : "123456", "password_confirmation" : "123456", mode: "admin" } }<br/>
{ "user" : { "username" : "user", "password" : "123456", "password_confirmation" : "123456", mode: "user" } }

# Login in:
/users/login (POST)
example: { "username" : "admin", "password" : "123456" }

