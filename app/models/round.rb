class Round < ActiveRecord::Base
  attr_accessible :closed, :expire_time, :max_amount, :secret_token, :url, :winning_address1, :winning_address2, :charity

  has_many :donations
  belongs_to :charity
  has_one :address

  after_initialize :generate_url
  after_initialize :setup_expire_time

  def generate_url
    self.url ||= SecureRandom.hex(3)
  end

  def setup_expire_time
    self.expire_time ||= Time.now + Rails.application.config.round_duration
  end

  def seconds_left
      [expire_time - Time.now, 0].max
  end

  def expired?
    expire_time < Time.now
  end

  def closed
    # expired rounds should be automatically closed
    self[:closed] ||= expired?
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

  def notify_subscribers
    realtime.trigger(url, 'new:charge', {})
  end

  def realtime
    Pusher
  end
end
