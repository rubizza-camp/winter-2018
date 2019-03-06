class DishesController < ApplicationController
  before_action :current_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @dishes = Dish.all
  end

  def show
    @dish = Dish.find(params[:id])
   end

  def new
    @dish = Dish.new
  end

  def create
  @dish = Dish.new(dish_params)
  if @dish.save
    flash[:success] = "Our dish is create!"
    redirect_to @dish
    else
      render 'new'
    end
  end

  def edit
    @dish = Dish.find(params[:id])
  end

  def update
    @dish = Dish.find(params[:id])
    if @dish.update_attributes(dish_params)
      flash[:success] = "Dish updated"
      redirect_to @dish
    else
      render 'edit'
    end
  end

  def destroy
    Dish.find(params[:id]).destroy
    flash[:success] = "Dish deleted."
    redirect_to dishes_url
  end

  private

  def dish_params
    params.require(:dish).permit(:name, :weight, :calorie_value, :proteins, :carbohydrates, :fats)
  end
end
