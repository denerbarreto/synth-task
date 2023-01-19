FROM ruby:3.0.0-alpine

RUN apk add --no-cache build-base postgresql-dev tzdata

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["rails", "server", "-b", "0.0.0.0"]