class Round < ActiveRecord::Base
  attr_accessible :closed, :expire_time, :max_amount, :secret_token, :url, :winning_address1, :winning_address2, :charity

  has_many :donations
  belongs_to :charity
  has_one :address

  after_initialize :generate_url
  after_initialize :setup_expire_time

  # length in characters of this round's url
  URL_LENGTH = 6

  def generate_url
    self.url ||= SecureRandom.hex(URL_LENGTH / 2)
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
    donations.max_by { |d| d.amount } if success?
  end

  def failed
    closed and donations.count < Rails.application.config.min_donations
  end

  def total_raised
    success? ? donations.inject(0) { |sum, donation| sum + donation.amount} : 0
  end

  def success?
    closed and not failed
  end

  def notify_subscribers
    realtime.trigger(url, 'new:charge', {})
  end

  def realtime
    Pusher
  end
end
