# frozen_string_literal: true

module IpMonitoring
  module Domain
    module Stats
      module Create
        class Operation < IpMonitoring::Operation
          include Deps[
            'domain.stats.create.contract',
            'repos.stat_repo'
          ]

          def call(params)
            params = step validate(params)
            statistic = step find_statistic(params)
            return statistic if statistic

            statistic = step calculate_statistic(params)
            step create(params, statistic)
          end

          private

          def find_statistic(params)
            Success(stat_repo.find_statistic(**params))
          rescue StandardError => e
            Hanami.logger.error(e.message)
            Failure[:internal_server_error, e.message]
          end

          def calculate_statistic(params)
            statistic = stat_repo.calculate(**params)
            return Success(statistic.first) if statistic.any?

            Failure[:bad_request, { statistic: 'not found' }]
          rescue StandardError => e
            Hanami.logger.error(e.message)
            Failure[:internal_server_error, e.message]
          end

          def create(params, statistic)
            Success(stat_repo.create(params.merge(statistic)))
          rescue StandardError => e
            Hanami.logger.error(e.message)
            Failure[:internal_server_error, e.message]
          end
        end
      end
    end
  end
end
