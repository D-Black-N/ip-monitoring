FROM ruby:3.4.4-slim

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      wget \
      gnupg \
      lsb-release \
      ca-certificates

RUN echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql-client-16 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install --jobs=4

COPY . .

EXPOSE 2300

# Стартовая команда (для разработки)
CMD ["bundle", "exec", "hanami", "server", "--host", "0.0.0.0"]