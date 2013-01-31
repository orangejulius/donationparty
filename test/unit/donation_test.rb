require 'test_helper'

class DonationTest < ActiveSupport::TestCase
  test "donation can return gravatar url" do
    @d = Donation.new(email: 'test1@example.com')

    assert_equal Rails.application.config.gravatar_url % "aa99b351245441b8ca95d54a52d2998c", @d.gravatar_url
  end
end
