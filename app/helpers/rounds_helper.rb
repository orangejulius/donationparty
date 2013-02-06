module RoundsHelper
  def new_round()
    r = Round.new
    if not r.save
      r.errors.each_full {|msg| puts msg}
    end
    '/round/' + r.url
  end
end
