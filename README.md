# Ticket Sales

JSON API for a ticket-selling platform with very simple features:
- Get info about an event
- Get info about available tickets
- Purchase one (or more) of available tickets

#### Setup

```bash
$ git clone https://github.com/aitorlb/ticket-sales
$ cd ticket-sales/
$ bundle install
$ bundle exec rake db:setup
$ bundle exec rspec
```

#### Run

```bash
$ bundle exec rails s
```

#### Sample calls

```bash
# GET all events
$ curl http://localhost:3000/api/v1/events
# Get info about an event
$ curl http://localhost:3000/api/v1/events/1
# Get available tickets
$ curl http://localhost:3000/api/v1/events/1/tickets
# Authenticate (a token will be returned)
$ curl -H "Content-Type: application/json" -X POST -d '{"email":"user@example.com","password":"password"}' http://localhost:3000/api/v1/authenticate
# Updates checkout cart (locks tickets for the user to allow time for collecting payment information)
curl -H "Authorization: <returned_token>" -H "Content-Type: application/json" -X PUT -d '{"ticket_count":"1"}' http://localhost:3000/api/v1/events/1/purchases
# Purchase one (or more) of available tickets (makes the actual purchase if payment is successful)
curl -H "Authorization: <returned_token>" -H "Content-Type: application/json" -X POST -d '{"ticket_count":"1", "payment_token":"payment_token"}' http://localhost:3000/api/v1/events/1/purchases
```