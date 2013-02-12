class Round < ActiveRecord::Base
  attr_accessible :closed, :expire_time, :max_amount, :secret_token, :url, :winning_address1, :winning_address2, :charity

  has_many :donations
  belongs_to :charity

  after_initialize do |round|
    self.url ||= SecureRandom.hex(3)
    self.expire_time ||= Time.now + Rails.application.config.round_duration
    save
  end

  def seconds_left
      [expire_time - Time.now, 0].max
  end

  def closed
    if not self[:closed]
      self[:closed] = self.expire_time < Time.now
    end
    self[:closed]
  end

  def winner
    donations.max_by { |d| d.amount } unless !closed or failed
  end

  def failed
    closed and donations.count < Rails.application.config.min_donations
  end

  def total_raised
    if closed and not failed
      donations.inject(0) { |sum, donation| sum + donation.amount}
    else
      0
    end
  end
end
