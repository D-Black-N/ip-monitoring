# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :checks do
      primary_key :id

      column :rtt_ms, Integer, null: false 
      column :failed, TrueClass, default: false
      column :loss, Float, null: false, default: 0.0

      foreign_key :ip_id, :ips, on_delete: :cascade, null: false
    end
  end
end
