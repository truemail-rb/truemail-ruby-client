# frozen_string_literal: true

RSpec.describe RequestHelper, type: :helper do
  describe '#have_sent_request_with' do
    let(:secure_connection) { true }
    let(:host) { FFaker::Internet.domain_name }
    let(:port) { rand(80..8080) }
    let(:token) { create_token }
    let(:method) { :get }
    let(:email) { FFaker::Internet.email }
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
        email: email,
        accept: accept,
        content_type: content_type,
        user_agent: user_agent
      }
    end

    def request(secure_connection:, host:, port:, token:, email:, accept:, content_type:, user_agent:, **) # rubocop:disable Metrics/ParameterLists
      Net::HTTP.start(host, port, use_ssl: secure_connection) do |http|
        request = Net::HTTP::Get.new(URI("#{secure_connection ? 'https' : 'http'}://#{host}:#{port}/?email=#{email}"))
        request['User-Agent'] = user_agent
        request['Accept'] = accept
        request['Content-Type'] = content_type
        request['Authorization'] = token
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

        include_examples 'checks request settings, stubs current request'
      end

      context 'when configuration settings not passed' do
        let(:request_configuration_settings) { {} }

        before { configure_client(configuration_settings) }

        include_examples 'checks request settings, stubs current request'
      end
    end

    context 'when request is not equal to mock' do
      specify do
        expect { request(**configuration_settings, **request_settings) }
          .to raise_error(WebMock::NetConnectNotAllowedError)
      end
    end
  end
end
