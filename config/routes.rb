# frozen_string_literal: true

module IpMonitoring
  class Routes < Hanami::Routes
    root to: 'home'

    scope 'api/v1' do
      get    '/ips/:id/stats', to: 'stats.create'

      post   '/ips', to: 'ips.create'
      post   'ips/:id/:state', to: 'ips.set_state'

      delete '/ips/:id', to: 'ips.delete'
    end
  end
end
