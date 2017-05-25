# Bank service

## Installing existing build

* docker run -p 80:80 -d absimas/bank

## Fresh build

* docker build -t absimas/bank .
* docker run -p 80:80 -d absimas/bank

## Endpoints

| Endpoint               | Actions                   | Explanation                                        |
| ---------------------- |:-------------------------:| --------------------------------------------------:|
|/accounts               | GET POST                  | list of accounts / account creation                |
|/accounts/1             | GET DELETE PUT PATCH      | actions with account with id 1                     |
|/accounts/1/sent        | GET                       | transactions sent by account with id 1             |
|/accounts/1/received    | GET                       | transactions received by account with id 1         |
|/transactions/account/1 | GET                       | all transactions associated with account with id 1 |
|/transactions           | GET POST                  | list of transactions / transaction creation        |
|/transactions/1         | GET PUT PATCH             | actions with transaction with id 1                 |

## Structure
### Account
```javascript
{
  "id": 1,
  "first_name": "Simas",
  "last_name": "Abramovas",
  "balance": 150.0
}
```

### Transaction
```javascript
{
"id": 1,
"sender_id": 1,
"receiver_id": 2,
"amount": 10.0
}
```

# External currency service
http://api.fixer.io/latest?symbols=GBP

## Endpoints
| Endpoint                   | Explanation            |
| -------------------------- | ----------------------:|
| /accounts/1/balance/EUR    | balance in euros       |
| /accounts/1/balance/USD    | balance in US dollars  |
| /accounts/1/balance/GBP    | balance in GB pounds   |
| /transactions/1/amount/EUR | amount in euros        |
| /transactions/1/amount/USD | amount in US dollars   |
| /transactions/1/amount/GBP | amount in GB pounds    |
