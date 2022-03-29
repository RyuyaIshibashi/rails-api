require 'rails_helper'
require 'user_authenticator'

describe UserAuthenticator do
  describe '#perform' do
    context 'when code is incorrect' do
      it 'should rise and error' do
        authenticator = described_class.new('sample_code')
        expect { authenticator.perform }.to raise_error(
          UserAuthenticator::AuthenticationError
        )
        expect(authenticator.user).to be_nil
      end
    end
  end
end
