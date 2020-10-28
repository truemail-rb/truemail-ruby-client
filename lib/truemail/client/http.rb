# frozen_string_literal: true

module Truemail
  module Client
    class Http
      require 'uri'
      require 'net/http'
      require 'json'

      URI_ATTRS = %i[secure_connection host port endpoint uri_params].freeze
      USER_AGENT = 'Truemail Ruby client'
      MIME_TYPE = 'application/json'
      VALIDATION_ENDPOINT = '/'
      HEALTHCHECK_ENDPOINT = '/healthcheck'

      def initialize(endpoint = Truemail::Client::Http::VALIDATION_ENDPOINT, **uri_params)
        Truemail::Client::Http::URI_ATTRS[0..2].each do |attribute|
          instance_variable_set(:"@#{attribute}", Truemail::Client.configuration.public_send(attribute))
        end
        @endpoint = endpoint
        @uri_params = uri_params
      end

      def run
        Net::HTTP.start(uri.host, uri.port, use_ssl: secure_connection) do |http|
          request = Net::HTTP::Get.new(uri)
          request['User-Agent'] = Truemail::Client::Http::USER_AGENT
          request['Accept'] = Truemail::Client::Http::MIME_TYPE
          request['Content-Type'] = Truemail::Client::Http::MIME_TYPE
          unless endpoint.eql?(Truemail::Client::Http::HEALTHCHECK_ENDPOINT)
            request['Authorization'] = Truemail::Client.configuration.token
          end
          http.request(request)
        end.body
      rescue => error
        { truemail_client_error: error }.to_json
      end

      private

      attr_reader(*Truemail::Client::Http::URI_ATTRS)

      def request_uri
        URI::HTTP.build(
          path: endpoint,
          query: uri_params.empty? ? nil : URI.encode_www_form(uri_params)
        ).request_uri
      end

      def uri
        @uri ||= URI("#{secure_connection ? 'https' : 'http'}://#{host}:#{port}#{request_uri}")
      end
    end
  end
end
