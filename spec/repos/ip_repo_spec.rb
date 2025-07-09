# frozen_string_literal: true

RSpec.describe IpMonitoring::Repos::IpRepo, :db do
  subject(:repo) { described_class.new }

  describe '#exist?' do
    let(:result) { repo.exist?(id) }
    let(:id) { 1 }

    it 'return false' do
      expect(result).to be_falsey
    end

    context 'when address already exist' do
      let(:ip) { Factory[:ip] }
      let(:id) { ip.id }

      it 'return true' do
        expect(result).to be_truthy
      end
    end
  end

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

  describe '#change_state' do
    let(:result) { repo.change_state(id, enabled) }
    let(:enabled) { true }

    context 'when record not found' do
      let(:id) { 1 }

      it 'return nil' do
        expect(result).to be_nil
      end
    end

    context 'with record' do
      let(:ip) { Factory[:ip] }
      let(:id) { ip.id }

      it 'update and return record' do
        expect(result.attributes).to eq(ip.attributes)
      end

      context 'with differend "enabled" field' do
        let(:enabled) { false }

        it 'update and return record' do
          expect(result.enabled).to be_falsey
        end
      end
    end
  end
end
