# frozen_string_literal: true

source 'https://rubygems.org'

gem 'hanami', '~> 2.2'
gem 'hanami-controller', '~> 2.2'
gem 'hanami-db', '~> 2.2'
gem 'hanami-router', '~> 2.2'
gem 'hanami-validations', '~> 2.2'

gem 'dry-operation'
gem 'dry-types', '~> 1.7'
gem 'pg'
gem 'puma'
gem 'rake'

# Translations
gem 'i18n'

# Daemonization processes
gem 'daemons'

# PING
gem 'net-ping'

group :development do
  gem 'hanami-webconsole', '~> 2.2'
end

group :development, :test do
  gem 'byebug'
  gem 'dotenv'
  gem 'rom-factory'
  gem 'rubocop'
end

group :cli, :development do
  gem 'hanami-reloader', '~> 2.2'
end

group :cli, :development, :test do
  gem 'hanami-rspec', '~> 2.2'
end

group :test do
  # Database
  gem 'database_cleaner-sequel'
  gem 'rack-test'
end
