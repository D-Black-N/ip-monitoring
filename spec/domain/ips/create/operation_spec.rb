# frozen_string_literal: true

RSpec.describe IpMonitoring::Domain::Ips::Create::Operation, '#call' do
  subject(:operation) { described_class.new(ip_repo: repo, contract: contract).call(params) }

  let(:repo) do
    instance_double(
      IpMonitoring::Repos::IpRepo,
      address_exist?: address_exist,
      activate_deleted: activate_deleted,
      create: ip_create
    )
  end
  let(:contract) { IpMonitoring::Domain::Ips::Create::Contract.new(repo: repo) }
  let(:address_exist) { false }
  let(:ip_create) { true }
  let(:activate_deleted) { true }

  context 'with success result' do
    let(:params) { { address: '8.8.8.8' } }

    context 'when create new record' do
      let(:activate_deleted) { false }

      it 'call repo.create and return success' do
        is_expected.to be_success
        expect(repo).to have_received(:create).once
      end
    end

    context 'when activate soft deleted record' do
      let(:ip) { Factory[:ip, deleted: true, address: params[:address]] }

      it "don't call repo.create and return success" do
        is_expected.to be_success
        expect(repo).not_to have_received(:create)
      end
    end
  end

  context 'with failure' do
    let(:failure) { operation.failure.first }

    context 'with invalid params' do
      let(:params) { {} }

      it 'failure with bad_request' do
        expect(failure).to eq(:bad_request)
      end
    end

    context 'when repo creation failure' do
      let(:params) { { address: '8.8.8.8' } }

      before { allow(repo).to receive(:activate_deleted).and_raise(StandardError) }

      it 'failure with internal_server_error' do
        expect(failure).to eq(:internal_server_error)
      end
    end
  end
end
