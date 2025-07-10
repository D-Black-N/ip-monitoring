# frozen_string_literal: true

module IpMonitoring
  module Actions
    module Ips
      class Delete < IpMonitoring::Action
        include Deps['domain.ips.delete.operation']

        params do
          required(:id).value(:integer)
        end

        def handle(request, response)
          case operation.call(request.params[:id])
          in Success(_)
            response.status = 204
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
