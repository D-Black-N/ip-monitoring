# frozen_string_literal: true

module IpMonitoring
  module Domain
    module Checks
      module Create
        class Contract < IpMonitoring::Contract
          option :repo, default: proc { Hanami.app['repos.ip_repo'] }

          params do
            required(:ip_id).value(:integer)
            required(:failed).value(:bool)
            required(:rtt_ms).maybe(:integer)
          end

          rule(:ip_id) do
            key.failure('must exist') unless repo.exist?(value)
          end

          rule(:rtt_ms) do
            key.failure('must be nil') if values[:failed] && value
            key.failure('must be positive') if value&.negative?
          end
        end
      end
    end
  end
end
