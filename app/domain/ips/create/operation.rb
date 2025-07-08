# frozen_string_literal: true

module IpMonitoring
  module Domain
    module Ips
      module Create
        class Operation < IpMonitoring::Operation
          include Deps[
            'domain.ips.create.contract',
            'repos.ip_repo'
          ]

          def call(params)
            params = step validate(params)
            ip_repo.create(params)
          rescue StandardError => e
            Hanami.logger.error(e.message)
            step Failure[:internal_server_error, e.message]
          end
        end
      end
    end
  end
end
