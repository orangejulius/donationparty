require 'test_helper'

class RoundFinishedJobTest < ActionController::TestCase
  setup do
    @charity = Charity.first
    @round = Round.create(charity: @charity)
  end

  test 'no emails sent if round not finished' do
    RoundFinishedJob.perform(@round.id)

    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  test 'no emails sent if round failed' do
    @round.update_attribute(:closed, true)
   
    RoundFinishedJob.perform(@round.id)

    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  test 'round success email sent to each participant if round was successful' do
    Rails.application.config.min_donations.times do
      Donation.create(round: @round, email: 'test@example.com')
    end

    @round.update_attribute(:closed, true)

    RoundFinishedJob.perform(@round.id)

    assert_equal @round.donations.count, ActionMailer::Base.deliveries.size
  end
end
