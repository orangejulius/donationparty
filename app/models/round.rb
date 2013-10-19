class Round < ActiveRecord::Base
  extend FriendlyId
  has_many :donations
  belongs_to :charity
  has_one :address

  friendly_id :url

  after_initialize :generate_url
  after_initialize :setup_expire_time

  # length in characters of this round's url
  URL_LENGTH = 6

  def generate_url
    self.url ||= SecureRandom.hex(URL_LENGTH / 2)
  end

  def setup_expire_time
    self.expire_time ||= (Time.now + Rails.application.config.round_duration).change(usec: 0)
  end

  def seconds_left
      [expire_time - Time.now, 0].max.round
  end

  def expired?
    expire_time < Time.now
  end

  def closed
    # expired rounds should be automatically closed
    self[:closed] ||= expired?
  end

  def winner
    donations.max_by(&:amount) if success?
  end

  def failed?
    closed and donations.count < Rails.application.config.min_donations
  end

  def total_raised
    success? ? donations.map(&:amount).inject(&:+) : 0
  end

  def success?
    closed and not failed?
  end

  def notify_subscribers
    Round.realtime.trigger(url, 'new:charge', {})
  end

  def self.realtime
    Pusher
  end
end
