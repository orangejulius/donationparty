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

  def charge
    @round = Round.find_by url: params[:round_id]

    @donation = Donation.new(round: @round, email: params[:email], name: params[:name], stripe_token: params[:stripe_token])
    @donation.charge
    @donation.save

    cookies['donated_'+@round.url] = @donation.token

    @round.notify_subscribers
    render status: :ok, nothing: true
  end

  def update_address
    if params[:url].nil? or params[:token].nil?
      render :nothing => true, :status => 403 and return
    end

    @round = Round.where(url: params[:url]).first

    if @round.winner.token != params[:token]
      render :nothing => true, :status => 403 and return
    end

    address = Address.new
    address.line1 = params[:address1]
    address.line2 = params[:address2]
    address.zip_code = params[:zip_code]
    address.city = params[:city]
    address.state = params[:state]
    address.country = params[:country]

    address.save

    @round.address = address
    @round.save

    redirect_to round_path(@round)
  end

  private
  def round_params
    params.require(:round).permit(:closed, :expire_time, :max_amount, :secret_token, :url, :winning_address1, :winning_address2)
  end
end
