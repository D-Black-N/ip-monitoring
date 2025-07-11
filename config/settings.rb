# frozen_string_literal: true

module IpMonitoring
  class Settings < Hanami::Settings
    setting :icmp_timeout, default: 1, constructor: Types::Params::Integer
    setting :thread_pool_size, default: 5, constructor: Types::Params::Integer
    setting :check_timeout, default: 60, constructor: Types::Params::Integer
  end
end
