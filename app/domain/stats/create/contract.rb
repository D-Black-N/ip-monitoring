# frozen_string_literal: true

module IpMonitoring
  module Domain
    module Stats
      module Create
        class Contract < IpMonitoring::Contract
          option :repo, default: proc { Hanami.app['repos.ip_repo'] }

          params do
            required(:ip_id).value(:integer)
            required(:time_from).value(:date_time)
            required(:time_to).value(:date_time)
          end

          rule(:ip_id) do
            key.failure('must exist') unless repo.exist?(value)
          end

          rule(:time_from, :time_to) do
            key.failure('time_from is greater than time_to') if values[:time_from] > values[:time_to]
          end
        end
      end
    end
  end
end
