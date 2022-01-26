# frozen_string_literal: true

RSpec.describe Truemail::Client::Configuration do
  subject(:configuration_instance) { described_class.new }

  let(:host) { FFaker::Internet.domain_name }
  let(:token) { create_token }

  describe 'defined constants' do
    specify { expect(described_class).to be_const_defined(:DEFAULT_PORT) }
  end

  describe '.new' do
    %i[secure_connection host port token].each do |attribute|
      it "has attr_accessor :#{attribute}" do
        expect(configuration_instance.respond_to?(attribute)).to be(true)
        expect(configuration_instance.respond_to?(:"#{attribute}=")).to be(true)
      end
    end

    context 'when block passed' do
      subject(:configuration_instance) { described_class.new(&configuration_block(host: host, token: token)) }

      it 'accepts block, sets values' do
        expect(configuration_instance.host).to eq(host)
        expect(configuration_instance.token).to eq(token)
      end
    end

    describe 'configuration cases' do
      context 'when auto configuration' do
        it 'sets configuration instance with default configuration template' do
          expect(configuration_instance.secure_connection).to be(false)
          expect(configuration_instance.port).to eq(Truemail::Client::Configuration::DEFAULT_PORT)
          expect(configuration_instance.host).to be_nil
          expect(configuration_instance.token).to be_nil
        end
      end

      context 'when manual independent configuration' do
        shared_examples 'sets accessor' do
          it 'sets accessor' do
            expect { configuration_instance.public_send("#{accessor}=", to_value) }
              .to change(configuration_instance, accessor)
              .from(from_value)
              .to(to_value)
          end
        end

        shared_examples 'raises argument error' do
          specify do
            invalid_argument = -42
            expect { configuration_instance.public_send("#{accessor}=", invalid_argument) }
              .to raise_error(
                Truemail::Client::Configuration::ArgumentError,
                "#{invalid_argument} is not a valid #{accessor}"
              )
          end
        end

        describe '#secure_connection' do
          let(:accessor) { :secure_connection }
          let(:from_value) { false }
          let(:to_value) { true }

          include_examples 'sets accessor'
        end

        describe '#host' do
          let(:accessor) { :host }

          context 'with valid host' do
            let(:from_value) { nil }
            let(:to_value) { host }

            include_examples 'sets accessor'
          end

          context 'with invalid host' do
            include_examples 'raises argument error'
          end
        end

        describe '#port' do
          let(:accessor) { :port }

          context 'with valid port' do
            let(:port) { 8080 }
            let(:from_value) { Truemail::Client::Configuration::DEFAULT_PORT }
            let(:to_value) { port }

            include_examples 'sets accessor'
          end

          context 'with invalid port' do
            include_examples 'raises argument error'
          end
        end

        describe '#token' do
          let(:accessor) { :token }

          context 'with valid token' do
            let(:from_value) { nil }
            let(:to_value) { token }

            include_examples 'sets accessor'
          end

          context 'with invalid token' do
            include_examples 'raises argument error'
          end
        end
      end
    end
  end

  describe '#complete?' do
    context 'when required args not passed' do
      specify { expect(configuration_instance.complete?).to be(false) }
    end

    context 'when required args passed' do
      let(:configuration_instance) { described_class.new(&configuration_block(host: host, token: token)) }

      specify { expect(configuration_instance.complete?).to be(true) }
    end
  end
end
