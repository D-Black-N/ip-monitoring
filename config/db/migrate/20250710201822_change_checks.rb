# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table(:checks) do
      drop_column :loss
      set_column_allow_null :rtt_ms
    end
  end
end
