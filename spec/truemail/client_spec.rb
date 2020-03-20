# frozen_string_literal: true

RSpec.describe Truemail::Client do
  describe 'defined constants' do
    specify { expect(described_class).to be_const_defined(:INCOMPLETE_CONFIG) }
  end

  describe 'global configuration methods' do
    let(:host) { 'example.com' }
    let(:token) { 'some_token' }
    let(:config_block) { configuration_block(host: host, token: token) }

    describe '.configure' do
      subject(:configure) { described_class.configure(&config_block) }

      context 'without block' do
        let(:config_block) {}

        specify { expect { configure }.not_to change(described_class, :configuration) }
        specify { expect(configure).to be_nil }
      end

      context 'with block' do
        context 'without required parameter' do
          let(:config_block) { configuration_block }

          specify do
            expect { configure }
              .to raise_error(Truemail::Client::Configuration::Error, Truemail::Client::INCOMPLETE_CONFIG)
          end
        end

        context 'with invalid argument' do
          let(:port) { -42 }
          let(:config_block) { configuration_block(port: port) }

          specify do
            expect { configure }
              .to raise_error(Truemail::Client::Configuration::ArgumentError, "#{port} is not a valid port")
          end
        end

        context 'with valid required arguments' do
          specify do
            expect { configure }
              .to change(described_class, :configuration)
              .from(nil).to(be_instance_of(Truemail::Client::Configuration))
          end

          it 'sets attributes into configuration instance' do
            expect(configure).to be_an_instance_of(Truemail::Client::Configuration)
            expect(described_class.configuration.host).to eq(host)
            expect(described_class.configuration.token).to eq(token)
          end
        end
      end
    end

    describe '.configuration' do
      subject(:configuration) { described_class.configuration }

      context 'when configuration was not set yet' do
        specify { expect(configuration).to be_nil }
      end

      context 'when configuration was successfully set' do
        before { described_class.configure(&config_block) }

        specify { expect(configuration).to be_instance_of(Truemail::Client::Configuration) }

        it 'accepts to rewrite current configuration settings' do
          secure_connection, new_host, port, new_token = true, 'new.com', 8080, 'new_token'

          expect do
            configuration.tap(&configuration_block(
              secure_connection: secure_connection,
              host: new_host,
              port: port,
              token: new_token
            ))
          end
            .to change(configuration, :secure_connection)
            .from(false).to(secure_connection)
            .and change(configuration, :host)
            .from(host).to(new_host)
            .and change(configuration, :port)
            .from(Truemail::Client::Configuration::DEFAULT_PORT).to(port)
            .and change(configuration, :token)
            .from(token).to(new_token)
        end
      end
    end

    describe '.reset_configuration!' do
      before { described_class.configure(&config_block) }

      specify do
        expect { described_class.reset_configuration! }
          .to change(described_class, :configuration)
          .from(be_instance_of(Truemail::Client::Configuration)).to(nil)
      end
    end
  end
end
