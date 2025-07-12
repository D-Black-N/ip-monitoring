# frozen_string_literal: true

RSpec.describe 'DELETE /api/v1/ips/:id', :db, type: :request do
  before do
    delete "/api/v1/ips/#{ip.id}", {}, { 'CONTENT_TYPE' => 'application/json' }
  end

  context 'with 204 success' do
    let(:ip) { Factory[:ip] }

    it 'delete IP', :aggregate_failures do
      expect(last_response.status).to eq(204)

      reloaded = Hanami.app['repos.ip_repo'].ips.by_pk(ip.id).one.attributes
      expect(reloaded).to include(deleted: true, enabled: false)
    end
  end

  context 'with 400 failure' do
    let(:ip) { Factory.structs[:stat] }

    it 'return bad_request' do
      expect(last_response.status).to eq(400)
      expect(response).to eq(errors: { id: ["IP with id=#{ip.id} must exist"] })
    end
  end
end
