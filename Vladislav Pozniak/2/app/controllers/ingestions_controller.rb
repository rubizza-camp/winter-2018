# frozen_string_literal: true

class IngestionsController < ApplicationController
  before_action :check_auth
  before_action :set_ingestion, only: %i[show edit update destroy]
  before_action :require_permission, only: %i[show edit update destroy]

  # GET /ingestions
  # GET /ingestions.json
  def index
    @ingestions = Ingestion.all
  end

  # GET /ingestions/1
  # GET /ingestions/1.json
  def show; end

  def stats
    render :stats
  end

  # GET /ingestions/new
  def new
    @ingestion = Ingestion.new
  end

  # GET /ingestions/1/edit
  def edit; end

  # POST /ingestions
  # POST /ingestions.json
  def create
    @ingestion = Ingestion.new(ingestion_params)
    collect_dishes
    create_response
  end

  # PATCH/PUT /ingestions/1
  # PATCH/PUT /ingestions/1.json
  def update
    @ingestion.dishes.clear
    collect_dishes
    update_response
  end

  # DELETE /ingestions/1
  # DELETE /ingestions/1.json
  def destroy
    @ingestion.destroy
    respond_to do |format|
      format.html { redirect_to ingestions_url, notice: 'Ingestion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_ingestion
    @ingestion = Ingestion.find(params[:id])
  rescue StandardError
    redirect_to ingestions_url, alert: 'You can not do it this way' unless @ingestion
  end

  def check_auth
    redirect_to login_url, alert: 'You need to be logged in' unless current_user
  end

  def require_permission
    return unless current_user != Ingestion.find(params[:id]).user
      redirect_to ingestions_url, alert: 'You do not have permissions to do it this way'
      # Or do something else here
    end
  end

  def collect_dishes
    params[:ingestion][:dish_ids].each do |dish_id|
      unless dish_id.empty?
        dish = Dish.find(dish_id)
        @ingestion.dishes << dish
      end
    end
  end

  def update_response
    respond_to do |format|
      if @ingestion.update(ingestion_params)
        format.html { redirect_to ingestions_url, notice: 'Ingestion was successfully updated.' }
        format.json { render :show, status: :ok, location: @ingestion }
      else
        format.html { render :edit }
        format.json { render json: @ingestion.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_response
    respond_to do |format|
      if @ingestion.save
        format.html { redirect_to ingestions_url, notice: 'Ingestion was successfully created.' }
        format.json { render :show, status: :created, location: @ingestion }
      else
        format.html { render :new }
        format.json { render json: @ingestion.errors, status: :unprocessable_entity }
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ingestion_params
    defaults = { user_id: current_user.id }
    params.require(:ingestion).permit(:time, :user_id, :dishes).reverse_merge(defaults)
  end
end
