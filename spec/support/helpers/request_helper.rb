# frozen_string_literal: true

module RequestHelper
  def have_sent_request_with(**request_settings) # rubocop:disable Metrics/AbcSize
    request = Request.new(**request_settings)

    HOST_PARAMS.each do |attribute|
      request.public_send(:"#{attribute}=", request_settings[attribute] || client_configuration.public_send(attribute))
    end

    url = "#{request.secure_connection ? 'https' : 'http'}://#{request.host}:#{request.port}/?email=#{request.email}"

    stub_request(request.method, url).with(
      headers: {
        'Accept' => request.accept,
        'Authorization' => request.token,
        'Content-Type' => request.content_type,
        'Host' => "#{request.host}:#{request.port}",
        'User-Agent' => request.user_agent
      }
    ).to_return(response(request.email))
  end

  private

  HOST_PARAMS = %i[secure_connection host port token].freeze
  REQUEST_PARAMS = %i[method email accept content_type user_agent].freeze
  Request = Struct.new(*(HOST_PARAMS | REQUEST_PARAMS), keyword_init: true)

  def response(email) # rubocop:disable Metrics/MethodLength
    {
      status: 200,
      body: {
        configuration: {
          blacklisted_domains: nil,
          email_pattern: 'default gem value',
          smtp_error_body_pattern: 'default gem value',
          smtp_safe_check: true,
          validation_type_by_domain: nil,
          whitelist_validation: false,
          whitelisted_domains: nil,
          not_rfc_mx_lookup_flow: false
        },
        date: Time.now,
        email: email,
        errors: nil,
        smtp_debug: nil,
        success: true,
        validation_type: 'smtp'
      }.to_json,
      headers: {}
    }
  end
end
