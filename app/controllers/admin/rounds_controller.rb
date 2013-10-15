class Admin::RoundsController < ApplicationController
  # GET /rounds
  def index
    @rounds = Round.all
  end

  # GET /rounds/1
  def show
    @round = Round.friendly.find(params[:id])
  end

  # GET /rounds/new
  def new
    @round = Round.new
  end

  # GET /rounds/1/edit
  def edit
    @round = Round.friendly.find(params[:id])
  end

  # POST /rounds
  def create
    @round = Round.new(round_params)

    if @round.save
      redirect_to [:admin, @round], notice: 'Round was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /rounds/1
  def update
    @round = Round.friendly.find(params[:id])

    if @round.update_attributes(round_params)
      redirect_to [:admin, @round], notice: 'Round was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /rounds/1
  def destroy
    @round = Round.friendly.find(params[:id])
    @round.destroy

    redirect_to admin_rounds_url
  end

  private
  def round_params
    params.require(:round).permit(:closed, :expire_time, :max_amount, :secret_token, :url)
  end
end
