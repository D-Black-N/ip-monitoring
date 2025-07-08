# auto_register: false
# frozen_string_literal: true

require "dry/operation"

module IpMonitoring
  class Operation < Dry::Operation
    private

    def contract
      raise NotImplementedError, I18n.t('base.not_implemented', name: 'contract')
    end

    def validate(params)
      contract.call(params).to_monad.fmap(&:to_h).or do |e|
        Failure[:bad_request, e.errors.to_hash]
      end
    end
  end
end
