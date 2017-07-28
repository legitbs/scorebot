FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" >> /etc/apt/sources.list.d/pgdg.list &&
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - &&
  apt-get update -qq &&
  apt-get install postgresql-client-9.6
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
