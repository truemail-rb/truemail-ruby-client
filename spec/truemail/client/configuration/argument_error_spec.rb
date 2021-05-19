# frozen_string_literal: true

RSpec.describe Truemail::Client::Configuration::ArgumentError do
  subject(:argument_error_instance) { described_class.new('arg_value', 'arg_name=') }

  specify { expect(described_class).to be < ::StandardError }
  specify { expect(argument_error_instance).to be_an_instance_of(described_class) }
  specify { expect(argument_error_instance.to_s).to eq('arg_value is not a valid arg_name') }
end
