# frozen_string_literal: true

RSpec.describe ConfigurationHelper, type: :helper do
  describe '#configuration_block' do
    let(:configuration_params) { { param_1: 1, param_2: 2 } }
    let(:configuration_instance) { ::Struct.new(*configuration_params.keys).new }

    before { configuration_block(**configuration_params).call(configuration_instance) }

    specify { expect(configuration_block).to be_an_instance_of(::Proc) }

    it 'sets configuration instance attributes' do
      configuration_params.each do |attribute, value|
        expect(configuration_instance.public_send(attribute)).to eq(value)
      end
    end
  end

  describe '#create_token' do
    it 'returns secure token' do
      expect(SecureRandom).to receive(:uuid).and_call_original
      expect(create_token).to be_an_instance_of(::String)
    end
  end

  describe '#configure_client' do
    subject(:configuration_builder) { configure_client(**params) }

    let(:params) { {} }

    context 'with default params' do
      it 'configures client, returns configuration instance with random host, token' do
        expect(Truemail::Client).to receive(:reset_configuration!).and_call_original
        expect(configuration_builder).to be_an_instance_of(Truemail::Client::Configuration)
        expect(configuration_builder.host).not_to be_nil
        expect(configuration_builder.token).not_to be_nil
      end
    end

    context 'with custom params' do
      let(:host) { FFaker::Internet.domain_name }
      let(:token) { create_token }
      let(:params) { { host: host, token: token } }

      it 'returns configuration instance with custom verifier email' do
        expect(Truemail::Client).to receive(:reset_configuration!).and_call_original
        expect(configuration_builder).to be_an_instance_of(Truemail::Client::Configuration)
        expect(configuration_builder.host).to eq(host)
        expect(configuration_builder.token).to eq(token)
      end
    end
  end

  describe '#client_configuration' do
    context 'when configuration has been configured' do
      before { configure_client }

      specify { expect(client_configuration).to be_an_instance_of(Truemail::Client::Configuration) }
    end

    context 'when configuration has not been configured' do
      specify { expect(client_configuration).to be_nil }
    end
  end
end
