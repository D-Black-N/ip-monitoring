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
            step create(params)
          end

          private

          def create(params)
            ip = ip_repo.activate_deleted(params[:address], params.fetch(:enabled, true))
            ip ||= ip_repo.create(params)

            Success(ip)
          rescue StandardError => e
            Hanami.logger.error(e.message)
            Failure[:internal_server_error, e.message]
          end
        end
      end
    end
  end
end
