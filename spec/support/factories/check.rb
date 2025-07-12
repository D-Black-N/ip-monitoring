# frozen_string_literal: true

Factory.define(:check) do |f|
  f.association :ip

  f.rtt_ms { rand(1..100) }
  f.failed false
end
