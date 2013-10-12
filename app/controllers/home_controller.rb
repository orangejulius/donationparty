class HomeController < ApplicationController
  def index
    @charities = Charity.limit(5)
  end
end
