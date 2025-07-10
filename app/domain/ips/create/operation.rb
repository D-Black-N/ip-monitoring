# frozen_string_literal: true
require 'byebug'

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
            create(params)
          rescue StandardError => e
            Hanami.logger.error(e.message)
            step Failure[:internal_server_error, e.message]
          end

          private

          def create(params)
            ip_repo.activate_deleted(params[:address], params.fetch(:enabled, true)) ||
              ip_repo.create(params)
          end
        end
      end
    end
  end
end
