# frozen_string_literal: true

RSpec.describe IpMonitoring::Domain::Ips::Delete::Operation do
  subject(:operation) { described_class.new(ip_repo: repo, contract: contract).call(id: id) }

  let(:contract) { IpMonitoring::Domain::Ips::Delete::Contract.new(repo: repo) }
  let(:repo) { instance_double(IpMonitoring::Repos::IpRepo, exist?: exist, soft_delete: true) }
  let(:id) { 1 }

  context 'with success result' do
    let(:exist) { true }

    it 'return success' do
      is_expected.to be_success
    end
  end

  context 'with failure' do
    let(:failure) { operation.failure.first }

    context 'with invalid params' do
      let(:id) { nil }

      it 'failure with bad_request' do
        expect(failure).to eq(:bad_request)
      end
    end
  end
end
