# frozen_string_literal: true

module IpMonitoring
  module Domain
    module Ips
      module Delete
        class Contract < IpMonitoring::Contract
          option :repo, default: proc { Hanami.app['repos.ip_repo'] }

          params do
            required(:id).value(:integer)
          end

          rule(:id) do
            key.failure("IP with id=#{value} must exist") unless repo.exist?(value)
          end
        end
      end
    end
  end
end
