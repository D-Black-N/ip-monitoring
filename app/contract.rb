# auto_register: false
# frozen_string_literal: true

require "dry-validation"

module IpMonitoring
  class Contract < Dry::Validation::Contract
    include Dry::Initializer

    config.messages.backend = :i18n
    config.messages.default_locale = I18n.default_locale

    Dry::Validation.load_extensions(:monads)
  end
end
