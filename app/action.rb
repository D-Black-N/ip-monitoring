# auto_register: false
# frozen_string_literal: true

require "hanami/action"
require "dry/monads"

module IpMonitoring
  class Action < Hanami::Action
    include Dry::Monads[:result]

    before :set_json_header, :validate_params

    private

    def set_json_header(_request, response)
      response.format = :json
    end

    def validate_params(request, _response)
      halt 422, { errors: request.params.errors }.to_json unless request.params.valid?
    end

    def bad_request(errors)
      halt 400, { errors: errors }.to_json
    end

    def internal_server_error
      halt 500, { errors: 'Internal Server Error' }.to_json
    end
  end
end
