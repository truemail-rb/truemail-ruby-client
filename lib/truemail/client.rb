# frozen_string_literal: true

require_relative '../truemail/client/version'
require_relative '../truemail/client/configuration'
require_relative '../truemail/client/http'

module Truemail
  module Client
    INCOMPLETE_CONFIG = 'required args not passed'
    NOT_CONFIGURED = 'use Truemail::Client.configure before'

    class << self
      def configuration(&block)
        @configuration ||= begin
          return unless block_given?
          configuration = Truemail::Client::Configuration.new(&block)
          raise_unless(configuration.complete?, Truemail::Client::INCOMPLETE_CONFIG)
          configuration
        end
      end

      def configure(&block)
        configuration(&block)
      end

      def reset_configuration!
        @configuration = nil
      end

      def validate(email)
        raise_unless(Truemail::Client.configuration, Truemail::Client::NOT_CONFIGURED)
        Truemail::Client::Http.new(email: email).run
      end

      def server_healthy?
        raise_unless(Truemail::Client.configuration, Truemail::Client::NOT_CONFIGURED)
        Truemail::Client::Http.new(Truemail::Client::Http::HEALTHCHECK_ENDPOINT).run.empty?
      end

      private

      def raise_unless(condition, message)
        raise Truemail::Client::Configuration::Error, message unless condition
      end
    end
  end
end
