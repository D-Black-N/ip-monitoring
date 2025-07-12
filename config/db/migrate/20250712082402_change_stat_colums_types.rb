# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table :stats do
      set_column_type :average_rtt_ms, :float
      set_column_type :rms_rtt_ms, :float
    end
  end
end
