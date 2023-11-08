# frozen_string_literal: true

module Truemail
  module Client
    module RspecHelper
      module Request
        def have_sent_request_with(**request_settings) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          request = Truemail::Client::RspecHelper::Request::Request.new(**request_settings)

          Truemail::Client::RspecHelper::Request::HOST_PARAMS.each do |attribute|
            request.public_send(:"#{attribute}=", request_settings[attribute] || client_configuration.public_send(attribute))
          end

          authorization = request.type.eql?(:public) ? {} : { 'Authorization' => request.token }
          request_params = request.params
          path = ::URI::HTTP.build(
            path: request.endpoint,
            query: request_params.empty? ? nil : ::URI.encode_www_form(request_params)
          ).request_uri

          url = "#{request.secure_connection ? 'https' : 'http'}://#{request.host}:#{request.port}#{path}"

          stub_request(request.method, url).with(
            headers: {
              'Accept' => request.accept,
              'Content-Type' => request.content_type,
              'Host' => "#{request.host}:#{request.port}",
              'User-Agent' => request.user_agent
            }.merge(authorization)
          ).to_return(response(**request_params))
        end

        private

        HOST_PARAMS = %i[secure_connection host port token].freeze
        REQUEST_PARAMS = %i[method accept content_type user_agent endpoint type params].freeze
        Request = ::Struct.new(*(HOST_PARAMS | REQUEST_PARAMS), keyword_init: true)

        def body(email) # rubocop:disable Metrics/MethodLength
          {
            configuration: {
              blacklisted_domains: nil,
              blacklisted_mx_ip_addresses: nil,
              dns: nil,
              email_pattern: 'default gem value',
              smtp_error_body_pattern: 'default gem value',
              smtp_safe_check: true,
              validation_type_by_domain: nil,
              whitelist_validation: false,
              whitelisted_domains: nil,
              not_rfc_mx_lookup_flow: false
            },
            date: ::Time.now,
            email: email,
            errors: nil,
            smtp_debug: nil,
            success: true,
            validation_type: 'smtp'
          }.to_json
        end

        def response(email: nil, **)
          {
            status: 200,
            body: email ? body(email) : '',
            headers: {}
          }
        end
      end
    end
  end
end
