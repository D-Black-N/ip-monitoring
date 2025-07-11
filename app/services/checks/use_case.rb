# frozen_string_literal: true

module IpMonitoring
  module Services
    module Checks
      class UseCase < IpMonitoring::Operation
        include Deps[
          send_icmp: 'domain.checks.send_icmp.operation',
          create: 'domain.checks.create.operation'
        ]
        
        def call(ip)
          check_params = step send_icmp.call(ip.address.to_s)
          step create.call(check_params.merge(ip_id: ip.id))
        end
      end
    end
  end
end
