# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table :events do
      add_column :created_at, DateTime, default: Sequel.lit('NOW()'), null: false
      add_column :time_from, DateTime
      add_column :time_to, DateTime
    end
  end
end
