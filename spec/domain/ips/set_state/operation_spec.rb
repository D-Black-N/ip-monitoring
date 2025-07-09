# frozen_string_literal: true

RSpec.describe IpMonitoring::Domain::Ips::SetState::Operation, '#call', :db do
  subject(:operation) { described_class.new(ip_repo: repo).call(params) }

  let(:repo) { instance_double(IpMonitoring::Repos::IpRepo, change_state: true) }

  context 'with success result' do
    let(:ip) { Factory[:ip] }
    let(:params) { { id: ip.id, state: 'enable' } }

    it { is_expected.to be_success }
  end

  context 'with failure result' do
    let(:failure) { operation.failure.first }

    context 'with invalid params' do
      let(:params) { {} }

      it 'failure with bad_request' do
        expect(failure).to eq(:bad_request)
      end
    end
  end
end
