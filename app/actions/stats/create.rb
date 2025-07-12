# frozen_string_literal: true

module IpMonitoring
  module Actions
    module Stats
      class Create < IpMonitoring::Action
        include Deps['domain.stats.create.operation']

        params do
          required(:id).value(:integer)
          required(:stats).hash do
            required(:time_from).value(:date_time)
            required(:time_to).value(:date_time)
          end
        end

        def handle(request, response)
          params = request.params[:stats].merge(ip_id: request.params[:id])

          case operation.call(params)
          in Success(stats)
            response.body = { stat: stats.attributes }.to_json
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
