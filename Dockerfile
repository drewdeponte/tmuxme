FROM ruby:2.2.2

RUN apt-get update -qq && apt-get install -y build-essential

# for postgresql
RUN apt-get install -y libpq-dev

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# for a JS runtime
RUN apt-get install -y nodejs

ENV APP_HOME /var/app 
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile $APP_HOME/
COPY Gemfile.lock $APP_HOME/
RUN bundle install

COPY . $APP_HOME
