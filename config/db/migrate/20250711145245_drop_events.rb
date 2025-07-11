# frozen_string_literal: true

ROM::SQL.migration do
  change do
    drop_table :events
  end
end
