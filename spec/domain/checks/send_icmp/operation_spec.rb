# frozen_string_literal: true

RSpec.describe IpMonitoring::Domain::Checks::SendICMP::Operation, '#call' do
  subject(:operation) { described_class.new.call(address) }

  context 'with success' do
    let(:address) { '8.8.8.8' }
    let(:response) { { failed: failed } }
    let(:ping) { instance_double(Net::Ping::External, ping?: !failed, duration: duration) }

    before { allow(Net::Ping::External).to receive(:new).and_return(ping) }

    context 'when ping success' do
      let(:failed) { false }
      let(:duration) { 1 }

      it 'return success with failed = false', :aggregate_failures do
        is_expected.to be_success
        expect(operation.success).to include(response)
      end
    end

    context 'when ping failed' do
      let(:failed) { true }
      let(:duration) { nil }

      it 'return success with failed = true', :aggregate_failures do
        is_expected.to be_success
        expect(operation.success).to include(response)
      end
    end
  end

  context 'with failure' do
    let(:failure) { operation.failure.first }

    context 'with validation error' do
      let(:address) { 11 }

      it 'failure and return bad_request', :aggregate_failures do
        is_expected.to be_failure
        expect(failure).to eq(:bad_request)
      end
    end
  end
end
