# Commands:

build image:<br/>
* docker-compose build<br/>

start server:<br/>
* docker-compose up<br/>

setup database:<br/>
* docker-compose run webapp rake db:setup

# Rest methods:
Verb	URI Pattern
*GET	/accounts(.:format)
*POST	/accounts(.:format)
*GET	/accounts/:id(.:format)
*PUT	/accounts/:id(.:format)
*GET	/payments(.:format)
*POST	/payments(.:format)
*GET	/payments/:id(.:format)
*GET	/branches(.:format)
*GET	/branches/:id(.:format)
