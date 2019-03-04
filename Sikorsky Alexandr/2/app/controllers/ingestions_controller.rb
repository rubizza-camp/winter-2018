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

    ingestion_params['dish_ids'].reject(&:empty?).each do |dish_id|
      dish = Dish.find(dish_id)
      @ingestion.dishes << dish
    end

    respond2create(@ingestion.save)
  end

  def update
    @ingestion.time = ingestion_params[:time]
    @ingestion.dishes.clear
    add_dishes

    respond2update(@ingestion)
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

  def respond2create(save_result)
    if save_result
      redirect_to ingestions_path, notice: 'ingestion was successfully added.'
    else
      render :new
    end
  end

  def respond2update(save_result)
    if save_result
      redirect_to ingestions_path, notice: 'ingestion was successfully updated.'
    else
      render :edit
    end
  end

  def ingestion_params
    @ingestion_params ||= params.require(:ingestion).permit(:time, dish_ids: [])
  end
end
