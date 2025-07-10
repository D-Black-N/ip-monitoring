# frozen_string_literal: true

RSpec.describe IpMonitoring::Repos::IpRepo, :db do
  subject(:repo) { described_class.new }

  describe '#avaliable' do
    let(:result) { repo.avaliable }

    it 'return blank' do
      expect(result).not_to be_exist
    end

    context 'when IP not deleted' do
      before { Factory[:ip] }

      it 'return scope' do
        expect(result).to be_exist
      end
    end

    context 'when IP deleted' do
      before { Factory[:ip, deleted: true] }

      it 'return blank' do
        expect(result).not_to be_exist
      end
    end
  end

  describe '#deleted' do
    let(:result) { repo.deleted }

    it 'return blank' do
      expect(result).not_to be_exist
    end

    context 'when IP not deleted' do
      before { Factory[:ip] }

      it 'return blank' do
        expect(result).not_to be_exist
      end
    end

    context 'when IP deleted' do
      before { Factory[:ip, deleted: true] }

      it 'return scope' do
        expect(result).to be_exist
      end
    end
  end

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

    context 'when address deleted' do
      let(:ip) { Factory[:ip, deleted: true] }
      let(:id) { ip.id }

      it 'return false' do
        expect(result).to be_falsey
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

    context 'when address deleted' do
      before { Factory[:ip, deleted: true] }

      it 'return false' do
        expect(result).to be_falsey
      end
    end
  end

  describe '#activate_deleted' do
    let(:result) { repo.activate_deleted(address, enabled) }
    let(:address) { '8.8.8.8' }
    let(:enabled) { true }

    it 'return false' do
      expect(result).to be_falsey
    end

    context 'when IP not deleted' do
      before { Factory[:ip, address: address] }

      it 'return false' do
        expect(result).to be_falsey
      end
    end

    context 'when IP deleted' do
      before { Factory[:ip, address: address, deleted: true, enabled: false] }

      it 'activate IP and return record', :aggregate_failures do
        expect(result).to be_a IpMonitoring::Structs::Ip
        expect(result.attributes).to include(deleted: false, enabled: true)
      end

      context 'when enabled not changed' do
        let(:enabled) { false }

      it 'activate IP and return record', :aggregate_failures do
        expect(result).to be_a IpMonitoring::Structs::Ip
        expect(result.attributes).to include(deleted: false, enabled: false)
      end
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

  describe '#soft_delete' do
    let(:result) { repo.soft_delete(id) }
    let(:id) { 1 }

    it 'update nothing' do
      expect(result).to eq(0)
    end

    context 'with record' do
      let(:ip) { Factory[:ip] }
      let(:id) { ip.id }

      it 'update record' do
        expect(result).to eq(1)
      end
    end
  end
end
