require 'test_helper'

class DonationTest < ActiveSupport::TestCase
  test "donation amount randomly generated on create" do
    mock_donation_get_random_amount

    d = Donation.new
    assert_equal DONATION_AMOUNT, d.amount
  end

  test "get_random_amount obeys app configuration" do
    1000.times do
      amount = Donation::get_random_amount
      assert amount > Rails.application.config.min_donation
      assert amount < Rails.application.config.max_donation
    end
  end

  test "donation can return gravatar url" do
    @d = Donation.new(email: 'test1@example.com')

    assert_equal Rails.application.config.gravatar_url % "aa99b351245441b8ca95d54a52d2998c", @d.gravatar_url
  end

  test "donation has randomly generated secret" do
    @donation = Donation.create(email: 'test@example.com')
    @donation2 = Donation.new

    assert_match /^[[:xdigit:]]{32}$/, @donation.secret
    assert_match /^[[:xdigit:]]{32}$/, @donation2.secret

    assert_not_equal @donation.secret, @donation2.secret

    @donation3 = Donation.find(@donation.id)

    assert_equal @donation.secret, @donation3.secret
  end

  test "donation validates presence of email" do
    @donation = Donation.new

    assert !@donation.save

    @donation.email = 'test@example.com'


    assert @donation.save
  end

  test "donation.token returns public token" do
    @donation = Donation.create(email: 'test@example.com')

    assert_match /^[[:xdigit:]]{40}$/, @donation.token
    assert_not_equal @donation.secret, @donation.token
  end

  test "donation can process charge via stripe" do
    token = 'test_stripe_token'

    @donation = Donation.create(stripe_token: token, email: 'test.email@example.com')

    stripeMock = mock('Charge')
    stripeMock.expects(:create).with(amount: @donation.cents, currency: 'usd', card: token, description: 'test.email@example.com')

    Donation.any_instance.stubs(:chargeObject).returns(stripeMock)

    charge = @donation.charge
  end
end
