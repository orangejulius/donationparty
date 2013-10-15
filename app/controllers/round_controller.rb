class RoundController < ApplicationController
  def create
    redirect_to root_url and return unless params[:charity]

    charity = Charity.find params[:charity]
    @round = Round.create(charity: charity)
    redirect_to round_path(@round)
  end

  def show
    @round = Round.friendly.find params[:id]

    @donated = cookies['donated_'+@round.url]
    if @round.winner
      @winner = cookies['donated_'+@round.url] == @round.winner.token
    end

    if @round.closed
      render :closed
    end
  end

  private
  def round_params
    params.require(:round).permit(:closed, :expire_time, :max_amount, :secret_token, :url)
  end
end
