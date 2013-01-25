module RoundsHelper
  def new_round()
    r = Round.new
    r.save
    '/round/' + r.url
  end
end
