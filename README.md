# Commands:

build image:<br/>
* docker-compose build<br/>

start server:<br/>
* docker-compose up<br/>

setup database:<br/>
* docker-compose run webapp rake db:setup

# Available methods:
Verb		URI Pattern
* GET		/accounts
* POST		/accounts(.:format)
* GET		/accounts/:id
* PUT		/accounts/:id(.:format)
* GET		/payments
* POST		/payments(.:format)
* GET		/payments/:id
* GET		/branches
* GET		/branches/:id
