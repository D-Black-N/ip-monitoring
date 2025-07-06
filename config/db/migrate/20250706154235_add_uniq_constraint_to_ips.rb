# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table :ips do
      add_unique_constraint :address
    end
  end
end
