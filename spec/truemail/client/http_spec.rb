# frozen_string_literal: true

RSpec.describe Truemail::Client::Http do
  describe 'defined constants' do
    specify { expect(described_class).to be_const_defined(:URI_ATTRS) }
    specify { expect(described_class).to be_const_defined(:USER_AGENT) }
    specify { expect(described_class).to be_const_defined(:MIME_TYPE) }
    specify { expect(described_class).to be_const_defined(:VALIDATION_ENDPOINT) }
    specify { expect(described_class).to be_const_defined(:HEALTHCHECK_ENDPOINT) }
  end

  describe '#run' do
    subject(:run) { described_class.new(endpoint, **request_params).run }

    let(:configuration_settings) { {} }
    let(:endpoint_type) { :private }

    before { configure_client(**configuration_settings) }

    context 'when connection successful' do
      shared_examples 'sends valid request to truemail api' do
        it 'sends valid request to truemail api' do
          have_sent_request_with(**request_settings)
          expect(run).to match_json_schema('connection_successful')
        end
      end

      context 'when validation endpoint' do
        let(:endpoint) { Truemail::Client::Http::VALIDATION_ENDPOINT }
        let(:request_params) { { email: FFaker::Internet.email } }
        let(:request_settings) do
          {
            method: :get,
            accept: 'application/json',
            content_type: 'application/json',
            user_agent: 'Truemail Ruby client',
            endpoint: endpoint,
            type: endpoint_type,
            params: request_params
          }
        end

        context 'when secure connection' do
          let(:configuration_settings) { { secure_connection: true } }

          include_examples 'sends valid request to truemail api'
        end

        context 'when not secure connection' do
          include_examples 'sends valid request to truemail api'
        end
      end

      context 'when healthcheck enpoint' do
        let(:endpoint) { Truemail::Client::Http::HEALTHCHECK_ENDPOINT }
        let(:endpoint_type) { :public }
        let(:request_params) { {} }
        let(:request_settings) do
          {
            method: :get,
            accept: 'application/json',
            content_type: 'application/json',
            user_agent: 'Truemail Ruby client',
            endpoint: endpoint,
            type: endpoint_type,
            params: request_params
          }
        end

        it 'sends valid request to truemail api' do
          have_sent_request_with(**request_settings)
          expect(run).to be_empty
        end
      end
    end

    context 'when connection fails' do
      let(:endpoint) { '/some_endpoint' }
      let(:request_params) { {} }
      let(:error) { 'error context' }

      it 'returns json with client error' do
        allow(::Net::HTTP).to receive(:start).and_raise(::SocketError, error)
        expect(run).to match_json_schema('connection_error')
      end
    end
  end
end
