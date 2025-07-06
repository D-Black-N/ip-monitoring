# frozen_string_literal: true

module IpMonitoring
  module Relations
    class Stats < IpMonitoring::DB::Relation
      schema :stats, infer: true do
        associations do
          belongs_to :ip
        end
      end
    end
  end
end
