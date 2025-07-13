# frozen_string_literal: true

require 'dry/inflector'

Inflector = Dry::Inflector.new do |inflections|
  inflections.acronym('ICMP')
end
