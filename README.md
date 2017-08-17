# Sidekiq::Retry::Monitor

Middleware for Sidekiq that reports to Rollbar if a job as retried a certain
number of times.

## Usage

Add the gem to your Gemfile.

```ruby
gem 'sidekiq_retry_monitor'
```

Configure Sidekiq to use the middleware provided by this gem.

```ruby
Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add SidekiqRetryMonitor::Middleware
  end
end
```

(Optionally) Configure a `SIDEKIQ_RETRIES_BEFORE_RAISING_ERROR` ENV which as
the name suggests controls the number of retries that occur before a Rollbar is
raised. If you do not set this ENV it defaults to 18 which works out to be
about five days of retrying.
