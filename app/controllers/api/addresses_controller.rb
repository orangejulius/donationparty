class Api::AddressesController < ApplicationController
  def create
    if params[:address].nil? or params[:address][:round_id].nil? or params[:round_token].nil?
      render nothing: true, status: 403 and return
    end

    @round = Round.friendly.find params[:address][:round_id]

    if @round.winner.token != params[:round_token]
      render nothing: true, status: 403 and return
    end

    @address = Address.create(address_params)

    redirect_to round_path(@round)
  end

  private
  def address_params
    params.require(:address).permit(:line1, :line2, :zip_code, :city, :state, :country, :round_id)
  end
end
