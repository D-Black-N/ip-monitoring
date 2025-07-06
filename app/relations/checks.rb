# frozen_string_literal: true

module IpMonitoring
  module Relations
    class Checks < IpMonitoring::DB::Relation
      schema :checks, infer: true do
        associations do
          belongs_to :ip
        end
      end
    end
  end
end
