class HomeController < ApplicationController
  def index
    @round = Round.create
  end
end
