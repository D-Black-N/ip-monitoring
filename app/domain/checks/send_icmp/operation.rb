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

            Hanami.logger.debug "[Thread: #{Thread.current.object_id}] [SendICMP] Address: #{address}"
            ping = Net::Ping::External.new(address, nil, settings.icmp_timeout)
            success = ping.ping?

            Hanami.logger.debug "[Thread: #{Thread.current.object_id}] [SendICMP] Address: #{address} - #{success}"
            { failed: !success, rtt_ms: ping.duration && ping.duration * 1000 }
          rescue NameError => e
            Hanami.logger.error(e.message)
            Failure[:internal_server_error, e.message]
          end
        end
      end
    end
  end
end
