# frozen_string_literal: true

module IpMonitoring
  module Repos
    class IpRepo < IpMonitoring::DB::Repo[:ips]
      commands :create, update: :by_pk

      def address_exist?(address)
        ips.exist?(address: address)
      end
    end
  end
end
