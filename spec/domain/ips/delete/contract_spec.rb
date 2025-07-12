# frozen_string_literal: true

RSpec.describe IpMonitoring::Domain::Ips::Delete::Contract, '#call' do
  subject(:contract) { described_class.new(repo: repo).call(id: id) }

  let(:repo) { instance_double(IpMonitoring::Repos::IpRepo, exist?: exist) }
  let(:id) { 1 }

  context 'with valid input' do
    let(:exist) { true }

    it { is_expected.to be_success }
  end

  context 'with invalid input' do
    let(:contract_errors) { contract.errors.to_hash }

    context 'with wrong id type' do
      let(:id) { 'a' }

      it { expect(contract_errors).to eq(id: ['must be an integer']) }
    end

    context 'when record not exist' do
      let(:exist) { false }

      it { expect(contract_errors).to eq(id: ["IP with id=#{id} must exist"]) }
    end
  end
end
