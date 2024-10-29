# ShiftManager v.1 (by Martin)

## Project Overview

Rails application that supports native iOS/Android apps through a REST API and features a web-based scheduling/admin system. 

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

This project uses Fly.io to deploy.

[How to run Fly on Rails app](https://www.fastruby.io/blog/deploying-rails-on-fly.html)

When you're all set you can deploy the app with only one command.

```ruby
fly deploy
```

You can find the app running [here](https://shiftmanager.fly.dev/).

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