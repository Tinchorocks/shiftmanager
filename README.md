# ShiftManager 

## Project Overview

Rails application that features a web-based scheduling/admin system. 

[Stack Used](Stack.md).

## Installation and setup

This project uses Docker to run. You should install Docker & Docker-compose. 

[How to install Docker](https://docs.docker.com/engine/install/).

[How to install Docker-compose](https://docs.docker.com/compose/install/).

1. Build docker image
  ```ruby
  docker-compose -f development.yml build
  ```
2. Start project
```ruby
docker-compose -f development.yml up
```

You can acccess to your started project in localhost:3000. 

## Running tests

With the project running, you can run all test with the next 2 commands

```ruby
docker exec -it shiftmanager_rails bash
bundle exec rspec 
```

## Deployment instructions 

Note: deployment for this app was removed since fly.io consumes resources ($$). I might add a Heroku free deploy later. 

## TODO

Pending items for a future version:
* [ ] Allow user to add notes (forgot to do this when adding the bonus features and i've only added the "acknowledge" feature). Notes exists but are only available for schedulers.
* [ ] Add sorting to both /admin/users and /shifts.
* [ ] Add filtering to both /admin/users and /shifts.
* [ ] Add pagination to both /admin/users and /shifts.
* [ ] Add more integration specs.
* [ ] Add feature tests using selenium.
* [ ] Add the ability to create/modify roles along with permissions (now its hardcoded in the seeds).
* [ ] Add shared contexts to specs to improve readability.
* [ ] Handle strings in views as translations with i18n.
* [ ] Add rubocop or any other code linter.
