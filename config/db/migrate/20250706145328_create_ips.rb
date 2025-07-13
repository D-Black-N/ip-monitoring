# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :ips do
      primary_key :id

      column :address, 'inet', null: false
      column :enabled, TrueClass, default: true, null: false
      column :deleted, TrueClass, default: false, null: false
      column :created_at, DateTime, default: Sequel.lit('NOW()'), null: false
      column :updated_at, DateTime, default: Sequel.lit('NOW()'), null: false
    end
  end
end
