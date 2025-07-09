# frozen_string_literal: true

RSpec.describe IpMonitoring::Domain::Ips::Create::Contract, '#call' do
  subject(:contract) { described_class.new(repo: repo).call(params) }

  let(:params) { { address: address, enabled: enabled }.compact }
  let(:repo) { instance_double(IpMonitoring::Repos::IpRepo, address_exist?: repo_value) }
  let(:repo_value) { false }

  context 'with valid params' do
    let(:address) { '8.8.8.8' }

    context 'without enabled key' do
      let(:enabled) { nil }

      it { is_expected.to be_success }
    end

    context 'with enabled' do
      let(:enabled) { true }

      it { is_expected.to be_success }
    end

    context 'with IPv6' do
      let(:address) { '::1' }
      let(:enabled) { nil }

      it { is_expected.to be_success }
    end
  end

  context 'with invalid params' do
    let(:address) { nil }
    let(:enabled) { nil }
    let(:contract_errors) { contract.errors.to_hash }

    context 'with required errors' do
      let(:errors) { { address: ['is missing'] } }

      it 'failure and return errors', :aggregate_failures do
        is_expected.to be_failure
        expect(contract_errors).to eq(errors)
      end
    end

    context 'when fields has wrong types' do
      let(:params) { { address: 1, enabled: nil } }
      let(:errors) { { address: ['must be a string'], enabled: ['must be boolean'] } }

      it 'failure and return errors', :aggregate_failures do
        is_expected.to be_failure
        expect(contract_errors).to eq(errors)
      end
    end

    context 'when IP is invalid' do
      let(:address) { '11' }
      let(:errors) { { address: ['invalid format'] } }

      it 'failure and return errors', :aggregate_failures do
        is_expected.to be_failure
        expect(contract_errors).to eq(errors)
      end
    end

    context 'when IP exist' do
      let(:address) { '8.8.8.8' }
      let(:errors) { { address: ['already exists'] } }
      let(:repo_value) { true }

      it 'failure and return errors', :aggregate_failures do
        is_expected.to be_failure
        expect(contract_errors).to eq(errors)
      end
    end
  end
end
