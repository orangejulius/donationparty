require 'test_helper'

class RoundObserverTest < ActiveSupport::TestCase
  test 'round_finished resque task enqued on round create' do
    round = Round.create

    assert_queued_at(round.expire_time, RoundFinishedJob, [round.id])
  end

end
