# frozen_string_literal: true

module IpMonitoring
  module Domain
    module Ips
      module SetState
        class Contract < IpMonitoring::Contract
          option :repo, default: proc { Hanami.app['repos.ip_repo'] }

          params do
            required(:id).value(:integer)
            required(:state).filled(:string, included_in?: %w[enable disable])
          end

          rule(:id) do
            key.failure("IP with id=#{value} must exist") unless repo.exist?(value)
          end
        end
      end
    end
  end
end
