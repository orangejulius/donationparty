class Api::DonationsController < ApplicationController
  def create
    @donation = Donation.new donation_params
    @donation.charge
    @donation.save

    cookies['donated_'+@donation.round.url] = @donation.token

    @donation.round.notify_subscribers
    render status: :ok, nothing: true
  end

  private
  def donation_params
    params.require(:donation).permit(:name, :email, :stripe_token, :round_id)
  end
end
