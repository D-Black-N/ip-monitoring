# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table :stats do
      add_column :time_from, DateTime
      add_column :time_to, DateTime
    end
  end
end
