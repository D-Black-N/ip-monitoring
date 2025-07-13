# frozen_string_literal: true

ROM::SQL.migration do
  up do
    alter_table :checks do
      add_constraint(
        :check_rtt_consistency,
        '(failed IS TRUE  AND rtt_ms IS NULL) OR (failed IS FALSE AND rtt_ms IS NOT NULL)'
      )
    end
  end

  down do
    alter_table :checks do
      drop_constraint :check_rtt_consistency, type: :check
    end
  end
end
