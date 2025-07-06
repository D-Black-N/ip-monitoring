# frozen_string_literal: true

module IpMonitoring
  module Relations
    class Ips < IpMonitoring::DB::Relation
      schema :ips, infer: true do
        associations do
          has_many :events
          has_many :checks
          has_many :stats
        end
      end
    end
  end
end
