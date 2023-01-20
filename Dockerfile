FROM ruby:3.0.0-alpine

RUN apk add --no-cache build-base postgresql-dev tzdata

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT [ "ash", "entrypoint.sh" ]

CMD ["rails", "server", "-b", "0.0.0.0"]