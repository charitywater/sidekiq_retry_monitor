require 'spec_helper'

describe SidekiqRetryMonitor::Middleware do
  describe '#call' do
    let(:worker) { 'FakeWorker' }
    let(:queue) { 'fake' }
    let(:job_params) do
      {
        'queue' => 'rollbar',
        'class' => 'Rollbar::Delay::Sidekiq',
        'jid' => 'be6345a52894f761459d0143',
        'args' => [
          'job_class' => 'ActionMailer::DeliveryJob',
          'job_id' => '2427fe00-b28a-4ebf-9040-dc1daf29677a',
          'arguments' => ['BrandPartnerMailer', 'welcome', 'deliver_now', 7],
        ],
      }
    end

    before do
      allow(ENV).to receive(:[]).with('SIDEKIQ_RETRIES_BEFORE_RAISING_ERROR') { 18 }
    end

    context 'when the job has not retried' do
      it 'does not report an exception to Rollbar' do
        expect(Rollbar).not_to receive(:error)
        subject.call(worker, job_params, queue) { nil }
      end
    end

    context 'when the job has a retry count that does not match the number of retries necessary to raise an error' do
      let(:job_params_with_some_retries) { job_params.merge({ 'retry_count' => 2 }) }

      it 'does not report an exception to Rollbar' do
        expect(Rollbar).not_to receive(:error)
        subject.call(worker, job_params_with_some_retries, queue) { nil }
      end
    end

    context 'when the job has a retry count that matches the number of retries necessary to raise an error' do
      let(:job_params_with_number_of_retries_before_raising_error) { job_params.merge({ 'retry_count' => 18 }) }

      it 'reports an exception to Rollbar' do
        expect(Rollbar).to receive(:error).with(an_instance_of(SidekiqRetryMonitor::SidekiqJobRetriedLotsOfTimes), job_id: job_params['jid'], job_class: job_params['class'], job_args: job_params['args'])
        subject.call(worker, job_params_with_number_of_retries_before_raising_error, queue) { nil }
      end
    end
  end
end
