class Api::DonationsController < ApplicationController
  def create
    @round = Round.friendly.find params[:round_id]

    @donation = Donation.new(round: @round, email: params[:email], name: params[:name], stripe_token: params[:stripe_token])
    @donation.charge
    @donation.save

    cookies['donated_'+@round.url] = @donation.token

    @round.notify_subscribers
    render status: :ok, nothing: true
  end
end
