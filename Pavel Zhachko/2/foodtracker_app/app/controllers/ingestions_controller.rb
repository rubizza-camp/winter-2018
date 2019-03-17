class IngestionsController < ApplicationController
  before_action :set_ingestion, only: %i[show edit update destroy]

  # GET /ingestions
  def index
    @ingestions = current_user.ingestions
  end

  # GET /ingestions/1
  def show; end

  # GET /ingestions/new
  def new
    @ingestion = current_user.ingestions.new
  end

  # GET /ingestions/1/edit
  def edit; end

  # POST /ingestions
  def create
    @ingestion = current_user.ingestions.new(ingestion_params)

    respond_to do |format|
      if @ingestion.save
        format.html { redirect_to @ingestion, notice: 'Ingestion was successfully created.' }
      else
        format.html { redirect_to new_ingestion_path }
      end
    end
  end

  # PATCH/PUT /ingestions/1
  def update
    respond_to do |format|
      if @ingestion.update(ingestion_params)
        format.html { redirect_to @ingestion, notice: 'Ingestion was successfully updated.' }
      else
        format.html { redirect_to @ingestion }
      end
    end
  end

  # DELETE /ingestions/1
  def destroy
    @ingestion.destroy
    respond_to do |format|
      format.html { redirect_to ingestions_url, notice: 'Ingestion was successfully destroyed.' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_ingestion
    @ingestion = Ingestion.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ingestion_params
    params.require(:ingestion).permit(:name, :time, dish_ids: [])
  end
end
