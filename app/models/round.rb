class Round < ActiveRecord::Base
  attr_accessible :closed, :expire_time, :failed, :max_amount, :secret_token, :url, :winning_address1, :winning_address2

  has_many :donations
  belongs_to :charity

  after_initialize do |round|
    if url.nil?
      self.url = SecureRandom.hex(3)
    end
    if expire_time.nil?
      self.expire_time = Time.now + Rails.application.config.round_duration
    end
    save
  end

  def seconds_left()
      [expire_time - Time.now, 0].max
  end

  def closed
    if not self[:closed]
      self[:closed] = self.expire_time < Time.now
    end
    self[:closed]
  end

  def winner
    if closed == false
      return nil
    end
    highest = nil
    donations.each do |donation|
      if highest.nil? or donation.amount > highest.amount
        highest = donation
      end
    end
    return highest
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
