# frozen_string_literal: true

Factory.define(:ip) do |f|
  f.address '8.8.8.8'
  f.enabled true
  f.deleted false
end
