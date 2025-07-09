# frozen_string_literal: true

module IpMonitoring
  module Domain
    module Ips
      module Create
        class Contract < IpMonitoring::Contract
          option :repo, default: proc { Hanami.app['repos.ip_repo'] }

          params do
            required(:address).value(:string)
            optional(:enabled).value(:bool)
          end

          rule(:address) do
            IPAddr.new(value)

            key.failure('already exists') if repo.address_exist?(value)
          rescue IPAddr::InvalidAddressError, ArgumentError
            key.failure('invalid format')
          end
        end
      end
    end
  end
end
