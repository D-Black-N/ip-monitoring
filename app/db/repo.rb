# frozen_string_literal: true

require 'hanami/db/repo'

module IpMonitoring
  module DB
    class Repo < Hanami::DB::Repo
      commands :create, update: :by_pk
    end
  end
end
