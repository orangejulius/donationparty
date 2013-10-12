class Admin::CharitiesController < ApplicationController
  # GET /charities
  def index
    @charities = Charity.all
  end

  # GET /charities/1
  def show
    @charity = Charity.find(params[:id])
  end

  # GET /charities/new
  def new
    @charity = Charity.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @charity }
    end
  end

  # GET /charities/1/edit
  def edit
    @charity = Charity.find(params[:id])
  end

  # POST /charities
  def create
    @charity = Charity.new(params[:charity])

    if @charity.save
      redirect_to [:admin, @charity], notice: 'Charity was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /charities/1
  def update
    @charity = Charity.find(params[:id])

    if @charity.update_attributes(params[:charity])
      redirect_to [:admin, @charity], notice: 'Charity was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /charities/1
  def destroy
    @charity = Charity.find(params[:id])
    @charity.destroy

    redirect_to admin_charities_url
  end
end
