# frozen_string_literal: true

module IpMonitoring
  module Domain
    module Ips
      module SetState
        class Operation < IpMonitoring::Operation
          include Deps[
            'domain.ips.set_state.contract',
            'repos.ip_repo'
          ]

          def call(params)
            params = step validate(params)
            ip_repo.change_state(params[:id], params[:state] == 'enable')
          end
        end
      end
    end
  end
end
