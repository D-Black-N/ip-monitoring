# frozen_string_literal: true

RSpec.describe IpMonitoring::Domain::Checks::Create::Contract, '#call' do
  subject(:contract) { described_class.new(repo: repo).call(params) }

  let(:repo) { instance_double(IpMonitoring::Repos::IpRepo, exist?: exist) }
  let(:exist) { true }

  context 'with valid params' do
    let(:params) { { ip_id: 1, rtt_ms: rtt_ms, failed: failed } }

    context 'with success ping' do
      let(:rtt_ms) { 2 }
      let(:failed) { false }

      it { is_expected.to be_success }
    end

    context 'with failed ping' do
      let(:rtt_ms) { nil }
      let(:failed) { true }

      it { is_expected.to be_success }
    end
  end

  context 'with invalid params' do
    let(:contract_errors) { contract.errors.to_hash }

    context 'when params empty' do
      let(:params) { {} }
      let(:errors) { { ip_id: ['is missing'], failed: ['is missing'], rtt_ms: ['is missing'] } }

      it 'return failure and errors', :aggregate_failures do
        is_expected.to be_failure
        expect(contract_errors).to eq(errors)
      end
    end

    context 'with types errors' do
      let(:params) { { ip_id: 'test', failed: 'test', rtt_ms: 'test' } }
      let(:errors) { { ip_id: ['must be an integer'], failed: ['must be boolean'], rtt_ms: ['must be an integer'] } }

      it 'return failure and errors', :aggregate_failures do
        is_expected.to be_failure
        expect(contract_errors).to eq(errors)
      end
    end

    context 'with rules errors' do
      let(:params) { { ip_id: 1, failed: failed, rtt_ms: rtt_ms } }
      let(:exist) { false }

      context 'when failed = true' do
        let(:failed) { true }
        let(:rtt_ms) { 2 }
        let(:errors) { { ip_id: ['must exist'], rtt_ms: ['must be nil'] } }

        it 'return failure and errors', :aggregate_failures do
          is_expected.to be_failure
          expect(contract_errors).to eq(errors)
        end
      end

      context 'when failed = false' do
        let(:failed) { false }
        let(:rtt_ms) { -1 }
        let(:exist) { true }
        let(:errors) { { rtt_ms: ['must be positive'] } }

        it 'return failure and errors', :aggregate_failures do
          is_expected.to be_failure
          expect(contract_errors).to eq(errors)
        end
      end
    end
  end
end
