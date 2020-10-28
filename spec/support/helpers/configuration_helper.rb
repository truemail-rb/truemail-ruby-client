# frozen_string_literal: true

require 'securerandom'

module ConfigurationHelper
  def configuration_block(**configuration_settings)
    lambda do |config|
      configuration_settings.each do |attribute, value|
        config.public_send(:"#{attribute}=", value)
      end
    end
  end

  def create_token
    SecureRandom.uuid
  end

  def configure_client(**configuration_settings)
    Truemail::Client.reset_configuration!
    configuration_settings[:host] = Faker::Internet.domain_name unless configuration_settings[:host]
    configuration_settings[:token] = create_token unless configuration_settings[:token]
    Truemail::Client.configure(&configuration_block(configuration_settings))
  end

  def client_configuration
    Truemail::Client.configuration
  end
end
