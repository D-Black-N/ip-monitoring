# frozen_string_literal: true

module IpMonitoring
  module Domain
    module Checks
      module Create
        class Contract < IpMonitoring::Contract
          params do
            required(:failed).value(:bool)
            required(:rtt_ms).maybe(:integer)
          end

          rule(:rtt_ms) do
            key.failure('must be nil') if values[:failed] && value
            key.failure('must be positive') if value && value.negative?
          end
        end
      end
    end
  end
end
