class AccessToken < ApplicationRecord
  belongs_to :user
  validates :token, presence: true

  after_initialize :generate_token

  private

  def generate_token
    loop do
      if token.present? \
      && !AccessToken.where.not(id: id).exists?(token: token)
        break
      end
      
      self.token = SecureRandom.hex(10)
    end
  end
end
