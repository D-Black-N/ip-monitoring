# frozen_string_literal: true

require 'concurrent'
require 'net/ping'

Daemons.run_proc('check_daemon', dir_mode: :normal, dir: 'tmp/pids', log_output: true) do
  Hanami.boot
  Hanami.logger.info("CheckDaemon started!")

  repo = Hanami.app['repos.ip_repo']
  use_case = Hanami.app['services.checks.use_case']
  settings = Hanami.app['settings']
  thread_pool = Concurrent::FixedThreadPool.new(settings.thread_pool_size)

  loop do
    Hanami.logger.info("Checking IPs...")

    repo.enabled_in_batches do |ips|
      ips.each do |ip|
        Hanami.logger.info("Processing IP: #{ip.address}")

        thread_pool.post do
          case use_case.call(ip)
          in Success(check)
            Hanami.logger.info("Processed IP: #{ip.address}")
          in Failure[key, errors]
            Hanami.logger.info("[#{ip.address}] [#{key}] #{errors}")
          end
        end
      end
    end

    sleep(settings.check_timeout)
  rescue StandardError => e
    Hanami.logger.error("CheckDaemon: #{e.message}")
    Hanami.logger.debug(e.backtrace.join("\n"))
    thread_pool.shutdown
    exit(1)
  end
end
