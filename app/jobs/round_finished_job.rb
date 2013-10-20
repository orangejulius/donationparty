class RoundFinishedJob
  @queue = :round_finished

  def self.perform(id)
    round = Round.find id
    if round.success?
      round.donations.each do |donation|
        RoundMailer.round_success(round, donation.email).deliver
      end
    end
  end

end
