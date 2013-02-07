class RoundsController < ApplicationController
  def set_charity
    @round = Round.where(url: params[:url]).first

    if @round.charity.nil?
      @round.charity = Charity.find(params[:charity])
      @round.save
    end

    render :display
  end

  def display
    @round = Round.where(url: params[:url]).first

    @donated = cookies['donated_'+@round.url]
    if @round.winner
      @winner = cookies['donated_'+@round.url] == @round.winner.token
    end

    if @round.closed
      render :closed
    end
  end

  def charge
    @round = Round.where(url: params[:round_id]).first

    @donation = Donation.new(round: @round, email: params[:email], name: params[:name], stripe_token: params[:stripeToken])
    @donation.save

    cookies['donated_'+@round.url] = @donation.token

    render_status
  end

  def status
    @round = Round.where(url: params[:url]).first
    render_status
  end

  def render_status
    @donated = cookies['donated_'+@round.url]
    @donations = render_to_string(partial: 'donations')
    @payment_info = render_to_string(partial: 'payment_info')
    render json: { 'seconds_left' => @round.seconds_left.round, 'donations_template' => @donations, 'payment_info_template' => @payment_info }
  end

  def update_address
    if params[:url].nil? or params[:token].nil?
      render :nothing => true, :status => 403 and return
    end

    @round = Round.where(url: params[:url]).first

    if @round.winner.token != params[:token]
      render :nothing => true, :status => 403 and return
    end

    @round.winning_address1 = params[:address1]
    @round.winning_address2 = params[:address2]
    @round.save

    render :nothing => true
  end

  # GET /rounds
  # GET /rounds.json
  def index
    @rounds = Round.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rounds }
    end
  end

  # GET /rounds/1
  # GET /rounds/1.json
  def show
    @round = Round.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @round }
    end
  end

  # GET /rounds/new
  # GET /rounds/new.json
  def new
    @round = Round.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @round }
    end
  end

  # GET /rounds/1/edit
  def edit
    @round = Round.find(params[:id])
  end

  # POST /rounds
  # POST /rounds.json
  def create
    @round = Round.new(params[:round])

    respond_to do |format|
      if @round.save
        format.html { redirect_to @round, notice: 'Round was successfully created.' }
        format.json { render json: @round, status: :created, location: @round }
      else
        format.html { render action: "new" }
        format.json { render json: @round.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /rounds/1
  # PUT /rounds/1.json
  def update
    @round = Round.find(params[:id])

    respond_to do |format|
      if @round.update_attributes(params[:round])
        format.html { redirect_to @round, notice: 'Round was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @round.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rounds/1
  # DELETE /rounds/1.json
  def destroy
    @round = Round.find(params[:id])
    @round.destroy

    respond_to do |format|
      format.html { redirect_to rounds_url }
      format.json { head :no_content }
    end
  end
end
