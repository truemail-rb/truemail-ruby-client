# frozen_string_literal: true

RSpec.describe Truemail::Client::Configuration::Error do
  specify { expect(described_class).to be < StandardError }
end
