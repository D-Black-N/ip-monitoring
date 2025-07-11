# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table :stats do
      add_column :created_at, DateTime, default: Sequel.lit('NOW()'), null: false
    end
  end
end
