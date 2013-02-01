class Donation < ActiveRecord::Base
  belongs_to :round
  attr_accessible :amount, :email, :name, :stripe_token, :round

  def gravatar_url
    Rails.application.config.gravatar_url % Digest::MD5.hexdigest(self.email)
  end
end
