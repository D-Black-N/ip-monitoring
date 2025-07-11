# frozen_string_literal: true

module IpMonitoring
  module Domain
    module Checks
      module Create
        class Operation < IpMonitoring::Operation
          include Deps[
            'domain.checks.create.contract',
            'repos.check_repo'
          ]

          def call(params)
            params = step validate(params)
            step create(params)
          end

          private

          def create(params)
            Success(check_repo.create(params))
          rescue StandardError => e
            Hanami.logger.error(e.message)
            Failure[:internal_server_error, e.message]
          end
        end
      end
    end
  end
end
