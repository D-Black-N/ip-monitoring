# frozen_string_literal: true

module IpMonitoring
  module Repos
    class IpRepo < IpMonitoring::DB::Repo[:ips]
      commands :create, :update, update: :by_pk

      def avaliable
        ips.where(deleted: false)
      end

      def deleted
        ips.where(deleted: true)
      end

      def exist?(id)
        avaliable.exist?(id: id)
      end

      def address_exist?(address)
        avaliable.exist?(address: address)
      end

      def activate_deleted(address, enabled)
        ip = deleted.where(address: address).one
        return false if ip.nil?

        update(ip.id, deleted: false, enabled: enabled)
        ips.by_pk(ip.id).one!
      end

      def change_state(id, enabled)
        ips.by_pk(id).one! if ips.by_pk(id).update(enabled: enabled).positive?
      end

      def soft_delete(id)
        ips.by_pk(id).update(enabled: false, deleted: true)
      end
    end
  end
end
