# frozen_string_literal: true

module IpMonitoring
  module Relations
    class Events < IpMonitoring::DB::Relation
      schema :events, infer: true do
        associations do
          belongs_to :ip
        end
      end
    end
  end
end
