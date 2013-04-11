ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  DONATION_AMOUNT = 5

  def mock_donation_get_random_amount
    Donation.expects(:get_random_amount).returns(DONATION_AMOUNT)
  end

  def stub_secure_random_hex(size_bytes)
    SecureRandom.expects(:hex).with(size_bytes).returns(fake_random_hex(size_bytes * 2))
  end

  def fake_random_hex(size)
    "x"*size
  end
end
