class Api::AddressesController < ApplicationController
  def create
    if params[:url].nil? or params[:token].nil?
      render nothing: true, status: 403 and return
    end

    @round = Round.find_by url: params[:url]

    if @round.winner.token != params[:token]
      render nothing: true, status: 403 and return
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
end
