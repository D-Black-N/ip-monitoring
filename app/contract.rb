# auto_register: false
# frozen_string_literal: true

require "dry-validation"

module IpMonitoring
  class Contract < Dry::Validation::Contract
    include Dry::Initializer

    config.messages.backend = :i18n
    Dry::Validation.load_extensions(:monads)
  end
end
