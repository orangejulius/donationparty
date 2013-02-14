class Donation < ActiveRecord::Base
  belongs_to :round
  attr_accessible :amount, :email, :name, :stripe_token, :round

  validates :email, :presence => true

  after_initialize do |donation|
    self.amount ||= rand(0.5..Rails.application.config.max_donation)
    self.secret ||= SecureRandom.hex(16)
    save
  end

  def gravatar_url
    Rails.application.config.gravatar_url % Digest::MD5.hexdigest(email)
  end

  def token
    Digest::SHA1.hexdigest(secret+email)
  end

  def charge
    cents = (amount*100).round

    charge = chargeObject.create(
      :amount => cents,
      :currency => "usd",
      :card => stripe_token,
      :description => email
    )
  end

  private

  def chargeObject
    Stripe::Charge
  end
end
