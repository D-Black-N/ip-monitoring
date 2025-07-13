# frozen_string_literal: true

RSpec.describe 'GET /api/v1/ips/:id/stats', :db, type: :request do
  let(:time_to) { Time.now }
  let(:ip) { Factory[:ip] }

  context 'with 200 success' do
    let(:params) { { stats: { time_from: (time_to - 60).to_s, time_to: time_to.to_s } } }

    context 'when return old statistic' do
      let!(:statistic) { Factory[:stat, ip_id: ip.id, **params[:stats]] }

      before do
        get "/api/v1/ips/#{ip.id}/stats", params, { 'CONTENT_TYPE' => 'application/json' }
      end

      it 'return already created statistic', :aggregate_failures do
        expect(last_response.status).to eq(200)
        expect(response[:stat]).to include(statistic.attributes.slice(:id, :ip_id, :min_rtt_ms))
      end
    end

    context 'when calculated new statistic' do
      let(:statistic) do
        { average_rtt_ms: 5.0, min_rtt_ms: 1, max_rtt_ms: 8, median_rtt_ms: 6, rms_rtt_ms: 3.61, loss: 25.0 }
      end

      before do
        # Участвуют в обработке
        Factory[:check, ip: ip, rtt_ms: 1, created_at: time_to - 50]
        Factory[:check, ip: ip, rtt_ms: 6, created_at: time_to - 40]
        Factory[:check, ip: ip, rtt_ms: 8, created_at: time_to - 30]
        Factory[:check, ip: ip, rtt_ms: nil, failed: true, created_at: time_to - 30]

        # НЕ участвуют в обработке
        Factory[:check, ip: ip, created_at: time_to - 70]
        Factory[:check, ip: Factory[:ip, address: '8.8.8.9'], created_at: time_to - 70]

        get "/api/v1/ips/#{ip.id}/stats", params, { 'CONTENT_TYPE' => 'application/json' }
      end

      it 'create statistic and return', :aggregate_failures do
        expect(last_response.status).to eq(200)
        expect(response[:stat]).to include(statistic)
      end
    end
  end

  context 'with 400 bad_request' do
    before do
      get "/api/v1/ips/#{ip.id}/stats", params, { 'CONTENT_TYPE' => 'application/json' }
    end

    let(:params) { { stats: { time_from: (time_to - 60).to_s, time_to: time_to.to_s } } }

    it 'return statistic not found', :aggregate_failures do
      expect(last_response.status).to eq(400)
      expect(response).to eq(errors: { statistic: 'not found' })
    end
  end

  context 'with 422 unprocessable_entity' do
    before do
      get "/api/v1/ips/#{ip.id}/stats", params, { 'CONTENT_TYPE' => 'application/json' }
    end

    let(:params) { {} }

    it 'return failure', :aggregate_failures do
      expect(last_response.status).to eq(422)
      expect(response).to eq(errors: { stats: ['is missing'] })
    end
  end
end
