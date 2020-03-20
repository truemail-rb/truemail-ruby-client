# frozen_string_literal: true

require 'truemail/client/version'
require 'truemail/client/configuration'

module Truemail
  module Client
    INCOMPLETE_CONFIG = 'required args not passed'

    class << self
      def configuration(&block)
        @configuration ||= begin
          return unless block_given?
          configuration = Truemail::Client::Configuration.new(&block)
          raise Truemail::Client::Configuration::Error, Truemail::Client::INCOMPLETE_CONFIG unless configuration.complete?
          configuration
        end
      end

      def configure(&block)
        configuration(&block)
      end

      def reset_configuration!
        @configuration = nil
      end
    end
  end
end
