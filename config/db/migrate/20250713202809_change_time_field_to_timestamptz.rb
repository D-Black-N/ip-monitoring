# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table :ips do
      set_column_type :created_at, 'timestamp with time zone'
      set_column_type :updated_at, 'timestamp with time zone'
    end

    alter_table :checks do
      set_column_type :created_at, 'timestamp with time zone'
    end

    alter_table :stats do
      set_column_type :created_at, 'timestamp with time zone'
      set_column_type :time_from, 'timestamp with time zone'
      set_column_type :time_to, 'timestamp with time zone'
    end
  end
end
