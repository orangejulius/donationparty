class Donation < ActiveRecord::Base
  belongs_to :round
  attr_accessible :amount, :email, :name, :stripe_token, :round

  validates :email, :presence => true

  after_initialize :select_donation_amount
  after_initialize :generate_secret

  def select_donation_amount
    self.amount ||= Donation::get_random_amount
  end

  def generate_secret
    self.secret ||= SecureRandom.hex(16)
  end

  def gravatar_url
    Rails.application.config.gravatar_url % Digest::MD5.hexdigest(email)
  end

  def token
    Digest::SHA1.hexdigest(secret+email)
  end

  def cents
    (amount * 100).round
  end

  def charge
    charge = chargeObject.create(
      :amount => cents,
      :currency => "usd",
      :card => stripe_token,
      :description => email
    )
  end

  private

  def self.get_random_amount
    rand(Rails.application.config.min_donation..
         Rails.application.config.max_donation)
  end

  def chargeObject
    Stripe::Charge
  end
end
