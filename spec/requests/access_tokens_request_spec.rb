require 'rails_helper'
require 'user_authenticator'

RSpec.describe "AccessTokens", type: :request do
  describe '#create' do

    context 'when no code provided' do
      subject { post '/login' }
      it_behaves_like "unauthorized_requests"
    end

    context 'when invalid request' do
      let(:github_error) {
        double("Sawyer::Resource", error: "bad_verification_code")
      }

      before do
        allow_any_instance_of(Octokit::Client).to receive(
          :exchange_code_for_token).and_return(github_error)
      end
      
      subject { post '/login', params: { code: 'invalid_code' } }

      it_behaves_like "unauthorized_requests"
    end

    context 'when success request' do
      let(:user_data) do
        {
          login: 'jsmith1',
          url: 'http://example.com',
          avatar_url: 'http://example.com/avator',
          name: 'Johon Smith'
        }
      end
      before do
        allow_any_instance_of(Octokit::Client).to receive(
          :exchange_code_for_token).and_return('valid_access_token')

        allow_any_instance_of(Octokit::Client).to receive(
          :user).and_return(user_data)
      end
      
      subject { post '/login', params: { code: 'valid_code' } }
      
      it 'should return 201 status code' do
        subject
        expect(response).to have_http_status(:created)
      end

      it "should return proper json body" do
        expect{ subject }.to change { User.count}.by(1)
        user = User.find_by(login: 'jsmith1')
        expect(json_data[:attributes]).to eq(
          { token: user.access_token.token }
        )
      end
    end
  end

  describe '#destroy' do
    subject { delete '/logout', headers: headers}

    context 'when no authorization header provided' do
      let(:headers) {{}}
      it_behaves_like 'forbidden_requests'
    end

    context 'when invalid authorization header provided' do
      let(:headers) {{ authorization: 'Invalid token' } }
      it_behaves_like 'forbidden_requests'
    end

    context 'when valid request' do
    end
  end
end
