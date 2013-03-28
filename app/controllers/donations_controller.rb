class DonationsController < ApplicationController
  def create
    @round = Round.where(url: params[:round_id]).first

    @donation = Donation.new(round: @round, email: params[:email], name: params[:name], stripe_token: params[:stripeToken])
    @donation.charge

    cookies['donated_'+@round.url] = @donation.token

    @round.notify_subscribers

    if @donation.save
      render json: @donation
    else
      render json: @donation.errors, status: :unprocessable_entity
    end
  end
end
