# frozen_string_literal: true

module IpMonitoring
  class Routes < Hanami::Routes
    root to: 'home'

    scope 'api/v1' do
      # get    '/ips/:id/stats', to: 'ips.stats'
      post   '/ips', to: 'ips.create'
      # post   'ips/:id/enable', to: 'ips.enable'
      # post   'ips/:id/disable', to: 'ips.disable'
      # delete '/ips/:id', to: 'ips.destroy'
    end
  end
end
