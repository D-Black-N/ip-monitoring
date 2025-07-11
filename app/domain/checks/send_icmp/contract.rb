# frozen_string_literal: true

module IpMonitoring
  module Domain
    module Checks
      module SendICMP
        class Contract < IpMonitoring::Contract
          params do
            required(:address).value(:string)
          end

          rule(:address) do
            IPAddr.new(value)
          rescue IPAddr::InvalidAddressError, ArgumentError
            key.failure('invalid format')
          end
        end
      end
    end
  end
end
