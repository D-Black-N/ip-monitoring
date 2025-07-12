# frozen_string_literal: true

Factory.define(:stat) do |f|
  f.association :ip

  f.average_rtt_ms { rand(1..100) }
  f.min_rtt_ms { rand(1..50) }
  f.max_rtt_ms { rand(50..200) }
  f.median_rtt_ms { rand(1..100) }
  f.rms_rtt_ms { rand(1..20) }
  f.loss { rand(0.0..1.0).round(2) }
end
