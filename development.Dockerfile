FROM ruby:3.2.2

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client build-essential libpq-dev
RUN mkdir /challenge
WORKDIR /challenge
RUN gem install bundler
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

EXPOSE 3000