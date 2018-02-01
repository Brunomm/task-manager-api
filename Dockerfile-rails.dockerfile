FROM ruby:2.4
LABEL manteiner="brunomergen@gmail.com"

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN gem install bundler
RUN gem install rails -v 5.0.2 --no-rdoc --no-ri


RUN mkdir -p /task-manager-api
WORKDIR /task-manager-api
VOLUME /task-manager-api

ADD Gemfile /task-manager-api/Gemfile
ADD Gemfile.lock /task-manager-api/Gemfile.lock

RUN bundle install

COPY . /task-manager-api