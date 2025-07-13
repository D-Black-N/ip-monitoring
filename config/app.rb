# frozen_string_literal: true

require 'hanami'
require 'i18n'

module IpMonitoring
  class App < Hanami::App
    require_relative '../lib/ip_monitoring/types'
    require_relative 'inflections'

    config.middleware.use :body_parser, :json
    config.inflector = Inflector

    I18n.load_path += Dir['config/locales/*.yml']
    I18n.available_locales = %i[en ru]
    I18n.default_locale = :en
  end
end
