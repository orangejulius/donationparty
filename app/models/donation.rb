class Donation < ActiveRecord::Base
  belongs_to :round
  attr_accessible :amount, :email, :name, :stripe_token, :round

  validates :email, :presence => true

  after_initialize do |donation|
    if amount.nil?
      self.amount = rand(0.0..Rails.application.config.max_donation)
    end
    if secret.nil?
      self.secret = SecureRandom.hex(16)
    end
    save
  end

  def gravatar_url
    Rails.application.config.gravatar_url % Digest::MD5.hexdigest(email)
  end

  def token
    Digest::SHA1.hexdigest(secret+email)
  end
end
