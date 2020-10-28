# frozen_string_literal: true

RSpec.describe Truemail::Client do
  describe 'defined constants' do
    specify { expect(described_class).to be_const_defined(:INCOMPLETE_CONFIG) }
    specify { expect(described_class).to be_const_defined(:NOT_CONFIGURED) }
  end

  describe 'global configuration methods' do
    let(:host) { Faker::Internet.domain_name }
    let(:token) { create_token }
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
          secure_connection, new_host, port, new_token = true, Faker::Internet.domain_name, 8080, create_token

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

  shared_examples 'global configuration was not set' do
    specify do
      expect { subject }
        .to raise_error(Truemail::Client::Configuration::Error, Truemail::Client::NOT_CONFIGURED)
    end
  end

  describe '.validate' do
    subject(:validate) { described_class.validate(email) }

    let(:email) { Faker::Internet.email }
    let(:http_instance) { instance_double('Http') }

    context 'when global configuration was set' do
      before { configure_client }

      it 'creates http instance, sends request' do
        expect(Truemail::Client::Http).to receive(:new).with(email: email).and_return(http_instance)
        expect(http_instance).to receive(:run)
        validate
      end
    end

    context 'when global configuration was not set' do
      it_behaves_like 'global configuration was not set'
    end
  end

  describe '.server_healthy?' do
    subject(:server_healthy) { described_class.server_healthy? }

    let(:http_instance) { instance_double('Http') }

    context 'when global configuration was set' do
      before do
        configure_client
        allow(Truemail::Client::Http)
          .to receive(:new).with(Truemail::Client::Http::HEALTHCHECK_ENDPOINT).and_return(http_instance)
        allow(http_instance).to receive(:run).and_return(healthcheck_result)
      end

      shared_examples 'returns server health status' do
        it 'returns server health status' do
          expect(server_healthy).to be(expectation)
        end
      end

      context 'when server is healthy' do
        let(:healthcheck_result) { '' }
        let(:expectation) { true }

        include_examples 'returns server health status'
      end

      context 'when server is not healthy' do
        let(:healthcheck_result) { 'some_response_context' }
        let(:expectation) { false }

        include_examples 'returns server health status'
      end
    end

    context 'when global configuration was not set' do
      it_behaves_like 'global configuration was not set'
    end
  end
end
