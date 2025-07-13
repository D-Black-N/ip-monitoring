# frozen_string_literal: true

RSpec.describe IpMonitoring::Services::Checks::UseCase do
  subject(:use_case) { described_class.new(send_icmp: send_icmp, create: create).call(ip) }

  let(:send_icmp) { instance_double(IpMonitoring::Domain::Checks::SendICMP::Operation, call: icmp_call) }
  let(:create) { instance_double(IpMonitoring::Domain::Checks::Create::Operation, call: create_call) }
  let(:ip) { Factory.structs[:ip] }
  let(:icmp_call) { true }
  let(:create_call) { true }

  context 'with success' do
    let(:params) { { failed: false, rtt_ms: 5 } }
    let(:icmp_call) { Success(params) }
    let(:create_call) { Success(Factory.structs[:check, **params].attributes) }

    it 'return check', :aggregate_failures do
      is_expected.to be_success
      expect(use_case).to eq(create_call)
    end
  end

  context 'when send_icmp failed' do
    let(:icmp_call) { Failure([:internal_server_error, { errors: 'Test' }]) }

    it 'return failrure icmp_call' do
      expect(use_case).to eq(icmp_call)
    end
  end

  context 'when create failure' do
    let(:params) { { failed: false, rtt_ms: 5 } }
    let(:icmp_call) { Success(params) }
    let(:create_call) { Failure([:internal_server_error, { errors: 'Test' }]) }

    it 'return failrure icmp_call' do
      expect(use_case).to eq(create_call)
    end
  end
end
