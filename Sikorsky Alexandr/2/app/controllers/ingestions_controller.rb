class IngestionsController < ApplicationController
  before_action :set_ingestion, only: %i[edit update destroy]

  def index
    @ingestions = current_user.ingestions
  end

  def new
    @ingestion = Ingestion.new
  end

  def edit; end

  def create
    @ingestion = current_user.ingestions.new(ingestion_params)
    if @ingestion.save
      redirect_to ingestions_path, notice: 'ingestion was successfully added.'
    else
      render :new
    end
  end

  def update
    if @ingestion.update(ingestion_params)
      redirect_to ingestions_path, notice: 'ingestion was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @ingestion.destroy

    redirect_to ingestions_path, notice: 'ingestion was successfully destroyed.'
  end

  private

  def add_dishes
    ingestion_params['dish_ids'].reject(&:empty?).each do |dish_id|
      dish = Dish.find(dish_id)
      @ingestion.dishes << dish
    end
  end

  def set_ingestion
    @ingestion = Ingestion.find(params[:id])
  end

  def ingestion_params
    @ingestion_params ||= params.require(:ingestion).permit(:time, dish_ids: [])
  end
end
