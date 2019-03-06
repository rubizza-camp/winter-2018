class IngestionsController < ApplicationController
  before_action :current_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]

  def index
    @ingestions = Ingestion.all
  end

  def show
    @ingestion = Ingestion.find(params[:id])
  end

  def new
    @ingestion = Ingestion.new
  end

  def create
    @ingestion = current_user.ingestions.new(ingestion_params)
    if @ingestion.save!
      flash[:success] = "Ingestion created!"
      render 'ingestions/index'
    else
      render 'static_pages/home'
    end
  end

  def edit
    @ingestion = Ingestion.find(params[:id])
  end

  def update
    @ingestion = Ingestion.find(params[:id])
    if @ingestion.update(ingestion_params)
      flash[:success] = "Ingestion updated"
      redirect_to @ingestion
    else
      render 'edit'
    end
  end

  def destroy
    Ingestion.find(params[:id]).destroy
    flash[:success] = "Ingestion deleted."
    redirect_to ingestions_url
  end

  private

  def ingestion_params
    defaults = { user_id: current_user.id }
    params.require(:ingestion).permit(:user_id, :dish_ids=>[])
  end

end
