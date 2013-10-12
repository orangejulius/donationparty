class Admin::RoundsController < ApplicationController
  # GET /rounds
  # GET /rounds.json
  def index
    @rounds = Round.all
  end

  # GET /rounds/1
  # GET /rounds/1.json
  def show
    @round = Round.find(params[:id])
  end

  # GET /rounds/new
  # GET /rounds/new.json
  def new
    @round = Round.new
  end

  # GET /rounds/1/edit
  def edit
    @round = Round.find(params[:id])
  end

  # POST /rounds
  # POST /rounds.json
  def create
    @round = Round.new(round_params)

    if @round.save
      redirect_to [:admin, @round], notice: 'Round was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /rounds/1
  # PUT /rounds/1.json
  def update
    @round = Round.find(params[:id])

    if @round.update_attributes(round_params)
      redirect_to [:admin, @round], notice: 'Round was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /rounds/1
  # DELETE /rounds/1.json
  def destroy
    @round = Round.find(params[:id])
    @round.destroy

    redirect_to admin_rounds_url
  end

  private
  def round_params
    params.require(:round).permit(:closed, :expire_time, :max_amount, :secret_token, :url, :winning_address1, :winning_address2)
  end
end
