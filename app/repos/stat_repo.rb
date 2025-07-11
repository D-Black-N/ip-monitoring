# frozen_string_literal: true

module IpMonitoring
  module Repos
    class StatRepo < IpMonitoring::DB::Repo[:stats]
      def find_statistic(ip_id:, time_from:, time_to:)
        stats.where(ip_id: ip_id, time_from: time_from, time_to: time_to).one
      end

      def calculate(ip_id:, time_from: , time_to:)
        database = Hanami.app["db.rom"].gateways[:default].connection

        query = <<~SQL
          SELECT
            ROUND(AVG(checks.rtt_ms), 2) AS average_rtt_ms,
            MIN(checks.rtt_ms) AS min_rtt_ms,
            MAX(checks.rtt_ms) AS max_rtt_ms,
            PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY checks.rtt_ms) AS median_rtt_ms,
            ROUND(STDDEV_SAMP(checks.rtt_ms), 2) AS rms_rtt_ms,
            ROUND((COUNT(*) FILTER (WHERE checks.failed = True) / COUNT(*)) * 100, 2) AS loss
          FROM checks
          WHERE checks.ip_id = ? AND checks.created_at BETWEEN ? AND ?
          GROUP BY checks.ip_id
        SQL

        database.fetch(query, ip_id, time_from, time_to).to_a
      end
    end
  end
end
