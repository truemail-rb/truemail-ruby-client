# frozen_string_literal: true

RSpec.describe Truemail::Client::Http do
  subject(:http_instance) { described_class.new(email: email) }

  let(:email) { FFaker::Internet.email }

  describe 'defined constants' do
    specify { expect(described_class).to be_const_defined(:URI_ATTRS) }
    specify { expect(described_class).to be_const_defined(:USER_AGENT) }
    specify { expect(described_class).to be_const_defined(:MIME_TYPE) }
    specify { expect(described_class).to be_const_defined(:VALIDATION_ENDPOINT) }
    specify { expect(described_class).to be_const_defined(:HEALTHCHECK_ENDPOINT) }
  end

  describe '#run' do
    subject(:run) { http_instance.run }

    let(:configuration_settings) { {} }

    before { configure_client(configuration_settings) }

    context 'when connection successful' do
      let(:request_settings) do
        {
          method: :get,
          accept: 'application/json',
          content_type: 'application/json',
          user_agent: 'Truemail Ruby client',
          email: email
        }
      end

      shared_examples 'sends valid request to truemail api' do
        it 'sends valid request to truemail api' do
          have_sent_request_with(request_settings)
          expect(run).to match_json_schema('connection_successful')
        end
      end

      context 'when secure connection' do
        let(:configuration_settings) { { secure_connection: true } }

        include_examples 'sends valid request to truemail api'
      end

      context 'when not secure connection' do
        include_examples 'sends valid request to truemail api'
      end
    end

    context 'when connection fails' do
      let(:error) { 'error context' }

      it 'returns json with client error' do
        allow(Net::HTTP).to receive(:start).and_raise(SocketError, error)
        expect(run).to match_json_schema('connection_error')
      end
    end
  end
end
