# frozen_string_literal: true

RSpec.describe IpMonitoring::Repos::IpRepo, :db do
  subject(:repo) { described_class.new }

  describe '#address_exist?' do
    let(:result) { repo.address_exist?('8.8.8.8') }

    it 'return false' do
      expect(result).to be_falsey
    end

    context 'when address already exist' do
      before { Factory[:ip] }

      it 'return true' do
        expect(result).to be_truthy
      end
    end
  end
end
