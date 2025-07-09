# frozen_string_literal: true

RSpec.describe 'POST /api/v1/ips/:id/:state', :db, type: :request do
  before do
    post "/api/v1/ips/#{id}/#{state}", {}, { 'CONTENT_TYPE' => 'application/json' }
  end

  context 'with success result' do
    let(:ip) { Factory[:ip] }
    let(:id) { ip.id }

    context 'with enabled set to false' do
      let(:state) { 'disable' }

      it 'return IP with enabled = false', :aggregate_failures do
        expect(last_response.status).to eq(200)
        expect(response[:ip]).to include(enabled: false)
      end
    end

    context 'with enabled set to true' do
      let(:ip) { Factory[:ip, enabled: false] }
      let(:state) { 'enable' }

      it 'return IP with enabled = true', :aggregate_failures do
        expect(last_response.status).to eq(200)
        expect(response[:ip]).to include(enabled: true)
      end
    end
  end

  context 'with 400 Bad Request' do
    let(:id) { 1 }
    let(:state) { 'aaa' }
    let(:errors) { { id: ["IP with id=#{id} must exist"], state: ['must be one of: enable, disable'] } }

    it 'failure and return 400', :aggregate_failures do
      expect(last_response.status).to eq(400)
      expect(response[:errors]).to include(errors)
    end
  end
end
