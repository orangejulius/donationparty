class RoundObserver < ActiveRecord::Observer

  def after_create(round)
    Resque.enqueue_at(round.expire_time, RoundFinishedJob, round.id)
  end

end
