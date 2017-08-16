require 'rollbar'

module SidekiqRetryMonitor
  class Middleware
    def call(_worker, job_params, _queue)
      raise SidekiqRetryMonitor::SidekiqJobRetriedLotsOfTimes, "The #{job_params['class']} job '#{job_params['jid']}' has retried #{job_params['retry_count']} times." if should_raise_error?(job_params['retry_count'])
    rescue SidekiqJobRetriedLotsOfTimes => e
      Rollbar.error(e, job_id: job_params['jid'], job_class: job_params['class'], job_args: job_params['args'])
    ensure
      yield
    end

    private

    def should_raise_error?(retry_count)
      retry_count == ENV['SIDEKIQ_RETRIES_BEFORE_RAISING_ERROR'].to_i
    end
  end

  class SidekiqJobRetriedLotsOfTimes < StandardError; end
end
