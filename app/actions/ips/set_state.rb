# frozen_string_literal: true

module IpMonitoring
  module Actions
    module Ips
      class SetState < IpMonitoring::Action
        include Deps['domain.ips.set_state.operation']

        params do
          required(:id).value(:integer)
          required(:state).filled(:string)
        end

        def handle(request, response)
          case operation.call(request.params.to_h)
          in Success(ip)
            response.body = { ip: ip.attributes }.to_json
          in Failure[:bad_request, errors]
            bad_request(errors)
          in Failure[:internal_server_error, _]
            internal_server_error
          end
        end
      end
    end
  end
end
