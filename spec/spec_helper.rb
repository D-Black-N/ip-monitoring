# frozen_string_literal: true

require 'pathname'
SPEC_ROOT = Pathname(__dir__).realpath.freeze

ENV['HANAMI_ENV'] = 'test'
require 'hanami/prepare'
require 'net/ping'
require_relative 'support/factories'

SPEC_ROOT.glob('support/**/*.rb').each { |f| require f }
