# frozen_string_literal: true

RSpec.describe IpMonitoring::Domain::Checks::SendICMP::Contract, '#call' do
  subject(:contract) { described_class.new.call(address: address) }

  context 'with valid input' do
    let(:address) { '::1' }

    it { is_expected.to be_success }
  end

  context 'with invalid input' do
    let(:failures) { contract.errors.to_hash }

    context 'with invalid type' do
      let(:address) { 111 }

      it { expect(failures).to eq(address: ['must be a string']) }
    end

    context 'when IP wrong' do
      let(:address) { 'aaaa' }

      it { expect(failures).to eq(address: ['invalid format']) }
    end
  end
end
