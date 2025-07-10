# frozen_string_literal: true

module IpMonitoring
  module Domain
    module Ips
      module Delete
        class Operation < IpMonitoring::Operation
          include Deps[
            'domain.ips.delete.contract',
            'repos.ip_repo'
          ]

          def call(params)
            params = step validate(params)
            ip_repo.soft_delete(params[:id])
          end
        end
      end
    end
  end
end
