require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  describe "#validations" do
    let(:access_token) { build :access_token }

    it 'should have valid factory' do
      expect(access_token).to be_valid
    end

    it 'should validate token' do
      access_token.token = ''
      expect(access_token).not_to be_valid
    end
  end

  describe '#new' do
    it 'should have a token presnet after initialize' do
      expect(AccessToken.new.token).to be_present
    end

    it 'should generate uniq token' do
      user = create :user
      expect{ user.create_access_token}.to change{ AccessToken.count }.by(1)
      expect(user.build_access_token).to be_valid
    end
  end
end
