class HomeController < ApplicationController
  def index
    @round = Round.create
    @charities = Charity.limit(5)
  end
end
