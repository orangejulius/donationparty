require 'test_helper'

class DonationTest < ActiveSupport::TestCase
  test "donation amount randomly generated on create" do
    d = Donation.new

    assert_not_nil d.amount
    assert d.amount > 0
    assert d.amount < Rails.application.config.max_donation
    assert_not_equal d.amount.to_i, d.amount, "donation amount should not be integer (most of the time)"

    d2 = Donation.new

    assert_not_equal d.amount, d2.amount
  end

  test "donation can return gravatar url" do
    @d = Donation.new(email: 'test1@example.com')

    assert_equal Rails.application.config.gravatar_url % "aa99b351245441b8ca95d54a52d2998c", @d.gravatar_url
  end
end
