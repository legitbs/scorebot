FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /scorebot ~/.ssh
WORKDIR /scorebot
ADD Gemfile /scorebot/Gemfile
ADD Gemfile.lock /scorebot/Gemfile.lock
RUN bundle install --retry=3 --jobs=4 --deployment
ADD tmp/scorebot_rsa ~/.ssh/id_rsa
ADD tmp/scorebot_rsa.pub ~/.ssh/id_rsa.pub
ADD . /scorebot
