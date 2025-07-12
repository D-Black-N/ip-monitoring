# frozen_string_literal: true

RSpec.describe IpMonitoring::Domain::Checks::Create::Operation, '#call' do
  subject(:operation) { described_class.new(contract: contract, check_repo: check_repo).call(params) }

  let(:contract) { IpMonitoring::Domain::Checks::Create::Contract.new(repo: ip_repo) }
  let(:check_repo) { instance_double(IpMonitoring::Repos::CheckRepo, create: true) }
  let(:ip_repo) { instance_double(IpMonitoring::Repos::IpRepo, exist?: true) }

  context 'with success result' do
    let(:params) { { ip_id: 1, failed: false, rtt_ms: 2 } }

    it { is_expected.to be_success }
  end

  context 'with failure' do
    let(:failure) { operation.failure.first }

    context 'with validation failure' do
      let(:params) { {} }

      it 'failure and return bad_request' do
        is_expected.to be_failure
        expect(failure).to eq(:bad_request)
      end
    end

    context 'with creation failure' do
      let(:params) { { ip_id: 1, failed: false, rtt_ms: 2 } }

      before { allow(check_repo).to receive(:create).and_raise }

      it 'failure and return internal_server_error', :aggregate_failures do
        is_expected.to be_failure
        expect(failure).to eq(:internal_server_error)
      end
    end
  end
end
