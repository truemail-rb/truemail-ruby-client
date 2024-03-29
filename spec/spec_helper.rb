# frozen_string_literal: true

rspec_custom = ::File.join(File.dirname(__FILE__), 'support/**/*.rb')
::Dir[::File.expand_path(rspec_custom)].sort.each { |file| require file unless file[/\A.+_spec\.rb\z/] }

require 'truemail/client'

RSpec.configure do |config|
  config.expect_with(:rspec) do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect
  end

  config.mock_with(:rspec) do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include Truemail::Client::RspecHelper::Configuration
  config.include Truemail::Client::RspecHelper::Request
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.order = :random
  config.before { Truemail::Client.reset_configuration! }

  ::Kernel.srand(config.seed)
end
