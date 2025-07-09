# frozen_string_literal: true

module IpMonitoring
  module Actions
    module Ips
      class Create < IpMonitoring::Action
        include Deps['domain.ips.create.operation']

        params do
          required(:ip).hash do
            required(:address).filled(:string)
            optional(:enabled).value(:bool)
          end
        end

        def handle(request, response)
          case operation.call(request.params[:ip])
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
