# frozen_string_literal: true

module IpMonitoring
  module Repos
    class CheckRepo < IpMonitoring::DB::Repo
      commands :create
    end
  end
end
