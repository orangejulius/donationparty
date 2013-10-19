require 'test_helper'

class DonationTest < ActiveSupport::TestCase
  def setup
    @round = Round.create
    @donation = Donation.create(round: @round, email: 'test1@example.com')
  end

  test "donation amount randomly generated on create" do
    mock_donation_get_random_amount

    d = Donation.new(email: 'test1@example.com')
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
    assert_equal Rails.application.config.gravatar_url % "aa99b351245441b8ca95d54a52d2998c", @donation.gravatar_url
  end

  test "donation has randomly generated secret" do
    stub_secure_random_hex(Donation::SECRET_LENGTH_BYTES)
    donation = Donation.create(email: 'test1@example.com')

    assert_equal fake_random_hex(Donation.secret_length), donation.secret
  end

  test "donation secret persists across save" do
    @donation.save
    @donation2 = Donation.find(@donation.id)

    assert_equal @donation.secret, @donation2.secret
  end

  test "donation validates presence of email" do
    @donation.email = nil

    assert !@donation.save
  end

  test "donation.token returns public token" do
    assert_match /^[[:xdigit:]]{40}$/, @donation.token
    assert_not_equal @donation.secret, @donation.token
  end

  test "donation can process charge via stripe" do
    token = 'test_stripe_token'

    donation = Donation.create(stripe_token: token, email: 'test.email@example.com')

    stripeMock = mock('Charge')
    stripeMock.expects(:create).with(amount: donation.cents, currency: 'usd', card: token, description: 'test.email@example.com')

    donation.stubs(:chargeObject).returns(stripeMock)

    donation.charge
  end
end
