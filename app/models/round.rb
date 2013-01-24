class Round < ActiveRecord::Base
  attr_accessible :charity, :closed, :expire_time, :failed, :max_amount, :secret_token, :url, :winning_address1, :winning_address2

  has_many :donations

  after_initialize do |round|
    self.url = SecureRandom.hex(3)
  end
end
