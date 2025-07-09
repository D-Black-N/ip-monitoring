# frozen_string_literal: true
require 'byebug'

RSpec.describe 'POST /api/v1/ips', :db, type: :request do
  before do
    post '/api/v1/ips', params.to_json, { 'CONTENT_TYPE' => 'application/json' }
  end

  context 'with success result' do
    let(:params) { { ip: { address: '8.8.8.8', enabled: enabled }.compact } }

    context 'with IPv6 address' do
      let(:params) { { ip: { address: '::1' } } }

      it 'create IPv6 and return 200', :aggregate_failures do
        expect(last_response.status).to eq(200)
        expect(response[:ip]).to include(params[:ip])
      end
    end

    context 'when enabled blank' do
      let(:enabled) { nil }

      it 'create enabled IP and return 200', :aggregate_failures do
        expect(last_response.status).to eq(200)
        expect(response[:ip]).to include(address: params.dig(:ip, :address), enabled: true)
      end
    end

    context 'with send "enabled" field' do
      let(:enabled) { false }

      it 'create disabled IP and return 200', :aggregate_failures do
        expect(last_response.status).to eq(200)
        expect(response[:ip]).to include(params[:ip])
      end
    end
  end

  context 'with 400 Bad Request' do
    let(:params) { { ip: { address: 'bad address' } } }

    it 'failure and return 400' do
      expect(last_response.status).to eq(400)
      expect(response[:errors]).to include(address: ['invalid format'])
    end
  end

  context 'with 422 Unprocessable Entity' do
    let(:params) { {} }

    it 'failure and return 422' do
      expect(last_response.status).to eq(422)
      expect(response[:errors]).to include(ip: ['is missing'])
    end
  end
end
