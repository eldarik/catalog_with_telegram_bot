# Base our image on an official, minimal image of our preferred Ruby
FROM ruby:2.6.1

ENV PROJECT_ROOT /usr/src/app

RUN find /var/lib/apt -type f -exec rm {} \+
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  postgresql-client \
  nodejs

RUN gem install bundler -v 2.0.1

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle install

WORKDIR $PROJECT_ROOT

COPY . .

RUN bundle exec rake assets:precompile
