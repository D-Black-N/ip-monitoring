# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :events do
      primary_key :id

      column :event_type, String, null: false
      column :created_at, DateTime, default: Sequel.lit('NOW()'), null: false

      foreign_key :ip_id, :ips, on_delete: :cascade, null: false
    end
  end
end
