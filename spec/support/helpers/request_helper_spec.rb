# frozen_string_literal: true

RSpec.describe RequestHelper, type: :helper do
  describe '#have_sent_request_with' do
    let(:secure_connection) { true }
    let(:host) { Faker::Internet.domain_name }
    let(:port) { rand(80..8080) }
    let(:token) { create_token }
    let(:method) { :get }
    let(:endpoint) { '/some_endpoint' }
    let(:request_params) { { email: Faker::Internet.email } }
    let(:accept) { 'accept_header' }
    let(:content_type) { 'content_type_header' }
    let(:user_agent) { 'user_agent_header' }
    let(:configuration_settings) do
      {
        secure_connection: secure_connection,
        host: host,
        port: port,
        token: token
      }
    end
    let(:request_settings) do
      {
        method: method,
        accept: accept,
        content_type: content_type,
        user_agent: user_agent,
        endpoint: endpoint,
        type: endpoint_type,
        params: request_params
      }
    end

    def request(secure_connection:, host:, port:, token:, accept:, content_type:, user_agent:, endpoint:, type:, params:, **) # rubocop:disable Metrics/ParameterLists
      ::Net::HTTP.start(host, port, use_ssl: secure_connection) do |http|
        path = ::URI::HTTP.build(
          path: endpoint,
          query: params.empty? ? nil : ::URI.encode_www_form(params)
        ).request_uri.gsub(/%40/, '@')
        request = ::Net::HTTP::Get.new(URI("#{secure_connection ? 'https' : 'http'}://#{host}:#{port}#{path}"))
        request['User-Agent'] = user_agent
        request['Accept'] = accept
        request['Content-Type'] = content_type
        request['Authorization'] = token if type.eql?(:private)
        http.request(request)
      end
    end

    context 'when request is equal to mock' do
      shared_examples 'checks request settings, stubs current request' do
        it 'checks request settings, stubs current request' do
          have_sent_request_with(**request_configuration_settings, **request_settings)
          expect(request(**configuration_settings, **request_settings)).to match_json_schema('connection_successful')
        end
      end

      context 'when all settings passed' do
        let(:request_configuration_settings) { configuration_settings }
        let(:endpoint_type) { :private }

        include_examples 'checks request settings, stubs current request'
      end

      context 'when configuration settings not passed' do
        let(:request_configuration_settings) { {} }
        let(:endpoint_type) { :public }

        before { configure_client(**configuration_settings) }

        include_examples 'checks request settings, stubs current request'
      end

      context 'when email not passed in params' do
        let(:request_configuration_settings) { configuration_settings }
        let(:request_params) { {} }
        let(:endpoint_type) { :public }

        it 'checks request settings, stubs current request' do
          have_sent_request_with(**request_configuration_settings, **request_settings)
          response = request(**configuration_settings, **request_settings)
          expect(response.code).to eq('200')
          expect(response.body).to be_empty
        end
      end
    end

    context 'when request is not equal to mock' do
      let(:endpoint_type) { :public }

      specify do
        expect { request(**configuration_settings, **request_settings) }
          .to raise_error(WebMock::NetConnectNotAllowedError)
      end
    end
  end
end
