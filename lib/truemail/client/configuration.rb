# frozen_string_literal: true

module Truemail
  module Client
    class Configuration
      DEFAULT_PORT = 9292

      Error = ::Class.new(::StandardError)
      ArgumentError = ::Class.new(::StandardError) do
        def initialize(arg_value, arg_name)
          super("#{arg_value} is not a valid #{arg_name[0..-2]}")
        end
      end

      attr_reader :host, :port, :token
      attr_accessor :secure_connection

      def initialize(&block)
        @secure_connection = false
        @port = Truemail::Client::Configuration::DEFAULT_PORT
        tap(&block) if block
      end

      %i[host port token].each do |method|
        define_method("#{method}=") do |argument|
          raise_unless(
            argument,
            __method__,
            method.eql?(:port) ? argument.is_a?(::Integer) && argument.positive? : argument.is_a?(::String)
          )
          instance_variable_set(:"@#{method}", argument)
        end
      end

      def complete?
        !!host && !!token
      end

      private

      def raise_unless(argument_context, argument_name, condition)
        raise Truemail::Client::Configuration::ArgumentError.new(argument_context, argument_name) unless condition
      end
    end
  end
end
