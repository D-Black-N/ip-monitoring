# frozen_string_literal: true

RSpec.describe IpMonitoring::Domain::Ips::Create::Operation, '#call' do
  subject(:operation) { described_class.new(ip_repo: repo).call(params) }

  let(:repo) { instance_double(IpMonitoring::Repos::IpRepo, address_exist?: address_exist, create: ip_create) }
  let(:address_exist) { false }
  let(:ip_create) { true }

  context 'with success result' do
    let(:params) { { address: '8.8.8.8' } }

    it { is_expected.to be_success }
  end

  context 'with failure' do
    context 'with invalid params' do
      let(:params) { {} }

      it 'failure with bad_request' do
        expect(operation.failure.first).to eq(:bad_request)
      end
    end

    context 'when repo creation failure' do
      let(:params) { { address: '8.8.8.8' } }

      before { allow(repo).to receive(:create).and_raise(StandardError) }

      it 'failure with internal_server_error' do
        expect(operation.failure.first).to eq(:internal_server_error)
      end
    end
  end
end
