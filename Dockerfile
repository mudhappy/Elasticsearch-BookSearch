FROM ruby:2.5.0
RUN apt-get update -qq && apt-get install -y build-essential sqlite3 nodejs vim
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp
