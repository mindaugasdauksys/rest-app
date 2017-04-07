# Commands:

build image:<br/>
* docker-compose build<br/>

start server:<br/>
* docker-compose up -d<br/>

setup database:<br/>
* docker-compose run -d webapp rake db:setup

# Available methods:
* GET    /accounts
* POST   /accounts(.:format)
* GET    /accounts/:id
* PATCH  /accounts/:id(.:format)
* DELETE /accounts/:id

* GET    /payments
* POST   /payments(.:format)
* GET    /payments/:id

* GET    /branches(.:format)
* GET    /branches/:id

