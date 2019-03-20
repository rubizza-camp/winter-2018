class UsersController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def new
    @user = User.new
  end

  def edit
    @user = User.find params.require(:id)
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
