class RoundFinishedJob
  @queue = :round_finished

  def self.perform(id)
    puts "performing #{self.class}!"
  end

end
