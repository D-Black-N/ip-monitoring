# frozen_string_literal: true

require 'rom-factory'
require 'faker'

Factory = ROM::Factory.configure do |config|
  config.rom = IpMonitoring::App.container['db.rom']
end

Dir[File.dirname(__FILE__) + '/factories/*.rb'].each { |file| require file }
