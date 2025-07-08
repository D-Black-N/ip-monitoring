# frozen_string_literal: true

module IpMonitoring
  module Actions
    class Home < IpMonitoring::Action
      def handle(request, response)
        response.body = { message: 'Server is avaliable' }.to_json
      end
    end
  end
end
