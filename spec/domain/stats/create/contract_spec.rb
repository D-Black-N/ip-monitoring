# frozen_string_literal: true

RSpec.describe IpMonitoring::Domain::Stats::Create::Contract do
  subject(:contract) { described_class.new(repo: repo).call(params) }

  let(:repo) { instance_double(IpMonitoring::Repos::IpRepo, exist?: exist) }
  let(:exist) { true }

  context 'with valid params' do
    let(:params) { { ip_id: 1, time_from: (Time.now - 60).to_s, time_to: Time.now.to_s } }

    it { is_expected.to be_success }
  end

  context 'with invalid params' do
    let(:failure) { contract.errors.to_hash }

    context 'with empty params' do
      let(:params) { {} }
      let(:errors) { { ip_id: ['is missing'], time_from: ['is missing'], time_to: ['is missing'] } }

      it 'failure and return errors' do
        is_expected.to be_failure
        expect(failure).to eq(errors)
      end
    end

    context 'with rules errors' do
      let(:time_from) { Time.now }
      let(:time_to) { time_from - 60 }
      let(:params) { { ip_id: 1, time_from: time_from.to_s, time_to: time_to.to_s } }
      let(:exist) { false }
      let(:errors) { { ip_id: ['must exist'], time_from: ['time_from is greater than time_to'] } }

      it 'failure and return errors' do
        is_expected.to be_failure
        expect(failure).to eq(errors)
      end
    end
  end
end
