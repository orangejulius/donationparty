class Api::RoundsController < ApplicationController
  respond_to :json

  def show
    @round = Round.friendly.find(params[:id])

    # TODO: move all this logic to the frontend
    @donated = cookies['donated_'+@round.url]
    @donations = render_to_string(partial: 'donations', formats: :html)
    @payment_info = render_to_string(partial: 'payment_info', formats: :html)
    render content_type: 'application/json'  # this is required due to the html format partials
  end
end
