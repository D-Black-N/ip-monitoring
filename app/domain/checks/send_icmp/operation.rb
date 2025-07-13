# frozen_string_literal: true

module IpMonitoring
  module Domain
    module Checks
      module SendICMP
        class Operation < IpMonitoring::Operation
          include Deps[
            'domain.checks.send_icmp.contract',
            'settings'
          ]

          def call(address)
            step validate(address: address)

            ping = Net::Ping::External.new(address, nil, settings.icmp_timeout)
            success = ping.ping?

            { failed: !success, rtt_ms: ping.duration && (ping.duration * 1000) }
          end
        end
      end
    end
  end
end
