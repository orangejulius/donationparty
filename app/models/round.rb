class Round < ActiveRecord::Base
  attr_accessible :charity, :closed, :expire_time, :failed, :max_amount, :secret_token, :url, :winning_address1, :winning_address2
  after_initialize do |round|
    self.url = SecureRandom.hex(6)
  end
end
