# frozen_string_literal: true

RSpec.describe IpMonitoring::Domain::Ips::SetState::Contract, '#call' do
  subject(:contract) { described_class.new(repo: repo).call(params) }

  let(:repo) { instance_double(IpMonitoring::Repos::IpRepo, exist?: repo_value) }
  let(:repo_value) { true }

  context 'with valid params' do
    let(:params) { { id: 1, state: 'enable' } }

    it { is_expected.to be_success }
  end

  context 'with invalid params' do
    let(:result) { contract.errors.to_hash }

    context 'with empty params' do
      let(:params) { {} }
      let(:errors) { { id: ['is missing'], state: ['is missing'] } }

      it 'failure and return errors', :aggregate_failures do
        is_expected.to be_failure
        expect(result).to eq(errors)
      end
    end

    context 'when record not found and state is invalid' do
      let(:params) { { id: 1, state: 'aaa' } }
      let(:errors) { { id: ["IP with id=#{params[:id]} must exist"], state: ['must be one of: enable, disable'] } }
      let(:repo_value) { false }

      it 'failure and return errors', :aggregate_failures do
        is_expected.to be_failure
        expect(result).to eq(errors)
      end
    end
  end
end
