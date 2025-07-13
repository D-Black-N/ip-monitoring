# frozen_string_literal: true

RSpec.describe IpMonitoring::Domain::Stats::Create::Operation, '#call' do
  subject(:operation) { described_class.new(stat_repo: stat_repo, contract: contract).call(params) }

  let(:contract) { IpMonitoring::Domain::Stats::Create::Contract.new(repo: ip_repo) }
  let(:stat_repo) do
    instance_double(
      IpMonitoring::Repos::StatRepo,
      find_statistic: find_statistic,
      calculate: calculate,
      create: create_stat
    )
  end
  let(:ip_repo) { instance_double(IpMonitoring::Repos::IpRepo, exist?: exist) }
  let(:find_statistic) { true }
  let(:calculate) { true }
  let(:create_stat) { true }
  let(:time_to) { Time.now }

  context 'with success result' do
    let(:params) { { ip_id: 1, time_from: (time_to - 60).to_s, time_to: time_to.to_s} }

    context 'when statistic exist' do
      let(:find_statistic) { Factory.structs[:stat, **params].attributes }

      it 'return finded statistic', :aggregate_failures do
        is_expected.to be_success
        expect(operation).to eq(Success(find_statistic))
      end
    end

    context 'when calculate new statistic' do
      let(:find_statistic) { nil }
      let(:calculate) { [Factory.structs[:stat, **params].attributes] }
      let(:create_stat) { calculate }

      it 'return finded statistic', :aggregate_failures do
        is_expected.to be_success
        expect(operation).to eq(Success(calculate))
      end
    end
  end

  context 'with failure' do
    let(:params) { { ip_id: 1, time_from: (time_to - 60).to_s, time_to: time_to.to_s} }

    context 'when validation failed' do
      let(:params) { {} }
      let(:errors) { { ip_id: ['is missing'], time_from: ['is missing'], time_to: ['is missing'] } }

      it 'failure and return bad_request', :aggregate_failures do
        is_expected.to be_failure
        expect(operation).to eq(Failure([:bad_request, errors]))
      end
    end

    context 'when find_statistic failed' do
      before { allow(stat_repo).to receive(:find_statistic).and_raise(StandardError.new('Test')) }

      it 'failure and return internal_server_error', :aggregate_failures do
        is_expected.to be_failure
        expect(operation).to eq(Failure([:internal_server_error, 'Test']))
      end
    end

    context 'when calculate statistic failed' do
      let(:find_statistic) { nil }

      context 'when calculate return []' do
        let(:calculate) { [] }

        it 'failure and return bad_request', :aggregate_failures do
          is_expected.to be_failure
          expect(operation).to eq(Failure([:bad_request, { statistic: 'not found' }]))
        end
      end

      context 'when calculate raised error' do
        before { allow(stat_repo).to receive(:calculate).and_raise(StandardError.new('Test')) }

        it 'failure and return internal_server_error', :aggregate_failures do
          is_expected.to be_failure
          expect(operation).to eq(Failure([:internal_server_error, 'Test']))
        end
      end
    end

    context 'when save statistic failed' do
      let(:find_statistic) { nil }
      let(:calculate) { [params] }

      before { allow(stat_repo).to receive(:create).and_raise(StandardError.new('Test')) }

      it 'failure and return internal_server_error', :aggregate_failures do
        is_expected.to be_failure
        expect(operation).to eq(Failure([:internal_server_error, 'Test']))
      end
    end
  end
end
