# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :stats do
      primary_key :id

      column :average_rtt_ms, Integer
      column :min_rtt_ms, Integer
      column :max_rtt_ms, Integer
      column :median_rtt_ms, Integer
      column :rms_rtt_ms, Integer
      column :loss, Float

      foreign_key :ip_id, :ips, on_delete: :cascade, null: false
    end
  end
end
