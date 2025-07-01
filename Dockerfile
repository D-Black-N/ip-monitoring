FROM ruby:3.4.4-slim

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install --jobs=4

COPY . .

EXPOSE 2300

# Стартовая команда (для разработки)
CMD ["bundle", "exec", "hanami", "server", "--host", "0.0.0.0"]