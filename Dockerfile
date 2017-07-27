FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /scorebot
WORKDIR /scorebot
ADD Gemfile /scorebot/Gemfile
ADD Gemfile.lock /scorebot/Gemfile.lock
RUN bundle install
RUN mkdir ~/.ssh
ADD tmp/scorebot_rsa /root/.ssh/id_rsa
ADD tmp/scorebot_rsa.pub /root/.ssh/id_rsa.pub
ADD tmp/known_hosts /root/.ssh/known_hosts
ADD . /scorebot
