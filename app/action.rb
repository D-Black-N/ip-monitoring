# auto_register: false
# frozen_string_literal: true

require "hanami/action"
require "dry/monads"

module IpMonitoring
  class Action < Hanami::Action
    include Dry::Monads[:result]

    before :set_json_header

    private

    def set_json_header(_request, response)
      response.format = :json
    end

    def bad_request(errors)
      halt 400, { errors: errors }.to_json
    end

    def unprocessable_entity(request)
      Hanami.logger.debug("\n=======================\n#{request.params.to_hash}\n")
      halt 422, { errors: request.params.errors }.to_json unless request.params.valid?
    end

    def internal_server_error
      halt 500, { errors: 'Internal Server Error' }.to_json
    end
  end
end
