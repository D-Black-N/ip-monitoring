# frozen_string_literal: true

RSpec.describe IpMonitoring::Repos::StatRepo, :db do
  subject(:repo) { described_class.new }

  describe '#find_statistic' do
    let(:result) { repo.find_statistic(ip_id: ip.id, time_from: stat.time_from, time_to: stat.time_to) }
    let(:stat) { Factory[:stat, ip: ip] }
    let(:ip) { Factory[:ip] }

    before do
      Factory[:stat, time_from: Time.now - 60 * 120, time_to: Time.now - 60 * 60, ip: ip]
    end

    it 'return stat with selected time range' do
      expect(result.id).to eq(stat.id)
    end

    context 'when record not found' do
      let(:result) { repo.find_statistic(ip_id: 1, time_from: Time.now, time_to: Time.now) }

      it 'raised error' do
        expect(result).to be_nil
      end
    end
  end

  describe '#calculate' do
    let(:result) { repo.calculate(ip_id: ip.id, time_from: time_from, time_to: time_to) }
    let(:ip) { Factory[:ip] }

    context 'when result blank' do
      let(:time_from) { Time.now }
      let(:time_to) { Time.now }

      it 'return empty array' do
        expect(result).to eq([])
      end
    end

    context 'with calculated result' do
      let(:time_to) { Time.now }
      let(:time_from) { time_to - 60 }
      let(:calculated) do
        [{ average_rtt_ms: 5.to_d, min_rtt_ms: 1, max_rtt_ms: 8, median_rtt_ms: 6.0, rms_rtt_ms: 3.61.to_d, loss: 25.to_d }]
      end

      before do
        # Участвуют в формировании статистики
        Factory[:check, ip: ip, rtt_ms: 1, created_at: time_to - 50]
        Factory[:check, ip: ip, rtt_ms: 6, created_at: time_to - 49]
        Factory[:check, ip: ip, rtt_ms: 8, created_at: time_to - 48]
        Factory[:check, ip: ip, rtt_ms: nil, failed: true, created_at: time_to - 47]

        # НЕ участвуют в формировании статистики
        Factory[:check, ip: ip, rtt_ms: 9, failed: false, created_at: time_from - 10]
        Factory[:check, ip: Factory[:ip, address: '8.8.8.9'], rtt_ms: 9]
      end

      it 'return calculated statistic' do
        expect(result).to eq(calculated)
      end
    end
  end
end
