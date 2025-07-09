# frozen_string_literal: true

module IpMonitoring
  module Repos
    class IpRepo < IpMonitoring::DB::Repo[:ips]
      commands :create, update: :by_pk

      def exist?(id)
        ips.exist?(id: id)
      end

      def address_exist?(address)
        ips.exist?(address: address)
      end

      def change_state(id, enabled)
        ips.by_pk(id).one! if ips.by_pk(id).update(enabled: enabled).positive?
      end
    end
  end
end
